class UsersController < ApplicationController
  before_action :set_user
  before_filter :correct_user, only: [:edit, :update]
  before_filter :journal_data, only: [:index, :new, :edit, :show, :users_rc, :journal_clear, :edit_notice, :edit_locale]
  before_filter :boss_authenticate, only: [:users_rc]
  before_filter :prime_admin_authenticate, only: [:destroy, :list_users, :add_user_for_project, :remove_user_for_project, :club_toggle, :update_score]
  before_filter :have_project_access
  before_filter :user_projects

  def new
    @user = User.new
    @title = 'Sign up'
  end

  def show
    @awards = Award.all

    if @user != current_user
      @journals = Journal.events_for_user_show @project.id, @user.id, 30
    else
      @journals = Journal.events_for_user_show @project.id, @user.id, 30
    end
  end

  def journal_clear
    if @my_journals.size > 0 and current_user?(@user)
      Journal.events_for_my_feed(@project.id, current_user).update_all(viewed: true)
      journal_data
    end

    respond_to do |format|
      format.js
    end
  end

  def edit
    add_breadcrumb "Редактирование профиля: #{@user}", edit_user_path(@project, @user)
  end

  def index
    if @project.type_access == 2
      @users = @project.users_in_project.where(users: {type_user: uniq_proc_users}).sort_by { |c| c.core_project_scores.by_project(@project).first.nil? ? 0 : c.core_project_scores.by_project(@project).first.score }.reverse!.uniq
    else
      @users = User.joins(:core_project_scores).where('core_project_scores.project_id = ? AND core_project_scores.score > 0', @project.id).where(users: {type_user: uniq_proc_users}).order("core_project_scores.score DESC")
    end
  end

  def add_user_for_project
    @project = Core::Project.find(params[:project])
    @user.core_project_users.create(project_id: @project.id) unless @user.core_project_users.by_project(@project.id).first
    respond_to do |format|
      format.js
    end
  end

  def remove_user_for_project
    @project = Core::Project.find(params[:project])
    @user.core_project_users.where(project_id: @project.id).destroy_all
    respond_to do |format|
      format.js
    end
  end

  def show_top
    @project = Core::Project.find(params[:project])
    if @project.type_access == 2
      @users = @project.users_in_project.where(users: {type_user: uniq_proc_users}).sort_by { |c| c.core_project_scores.by_project(@project).first.nil? ? 0 : c.core_project_scores.by_project(@project).first.send(params[:score_name]) }.reverse!.uniq
    else
      @users = User.joins(:core_project_scores).where('core_project_scores.project_id = ? AND core_project_scores.score > 0', @project.id).where(users: {type_user: uniq_proc_users}).order(score_order(params[:score_name]))
    end
    @score_name = params[:score_name]
    respond_to do |format|
      format.js
    end
  end

  def users_rc
    @project = Core::Project.find(params[:project])
    @users = User.where(type_user: [4, 7]).order('score DESC').paginate(page: params[:page])
  end

  def list_users
    @project = Core::Project.find(params[:project])
    @added_users = User.joins(:core_project_users).where('core_project_users.project_id = ?', @project.id).order('users.id DESC')
    @users = User.without_added(@added_users.pluck(:id)).order('id DESC').paginate(page: params[:page])
    respond_to do |format|
      format.html { render layout: 'core/list_projects' }
      format.js
    end
  end

  def search_users
    @search_users = User.where('LOWER(name) like LOWER(?) OR LOWER(surname) like LOWER(?) OR LOWER(email) like LOWER(?)', "%#{params[:search_users_text]}%", "%#{params[:search_users_text]}%", "%#{params[:search_users_text]}%").order('id DESC')
    @search_users.sort_by { |ha| ha[:name].downcase or ha[:surname].downcase or ha[:email].downcase }
  end

  def update_score
    @project = Core::Project.find(params[:project])
    params[:value] = '0' if params[:value] == ''
    respond_to do |format|
      if @user.update_attributes(params[:name] => params[:value])
        format.json { head :no_content } # 204 No Content
        format.js { head :no_content }
      end
    end
  end

  def club_toggle
    @project = Core::Project.find(params[:project])
    respond_to do |format|
      if @user.update_attributes!(type_user: club_toggle_user(@user))
        format.js
      end
    end
  end

  def update
    @project = Core::Project.find(params[:project])
    params[:user].delete(:password) if params[:user][:password].blank?
    if @user.update_attributes(params[:user])
      flash[:success] = 'Профиль обновлен'
      redirect_to user_path(@project, @user)
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'Пользователь удален!!'
    redirect_to users_path
  end

  def add_score
    if boss?
      @project = Core::Project.find(params[:project])
      @user.add_score_by_type(@project, params[:score].to_i, :score_a)
      @user.journals.build(type_event: 'add_score', project: @project, body: params[:score]).save
      current_user.journals.build(type_event: 'my_add_score', user_informed: @user, project: @project, body: params[:score], viewed: false).save!
    end
    respond_to do |format|
      format.js
    end
  end

  def add_score_essay
    if boss?
      @project = Core::Project.find(params[:project])
      @user.journals.build(type_event: 'add_score_essay', project: @project, body: params[:score]).save
    end
    render json: @user.score
  end

  def edit_notice
    @auto_feed_mailer = current_user.user_checks.where(project_id: @project.id, check_field: 'auto_feed_mailer').first
    @journal_mailer = JournalMailer.new
    @mailers = prime_admin? ? @project.journal_mailers : @project.journal_mailers.mailers_for_moderator(current_user)
  end

  def create_notice
    @project = Core::Project.find(params[:project])
    @post = @project.journal_mailers.build(params[:journal_mailer])
    @post.user = current_user
    @post.project = @project
    @post.status = 0
    respond_to do |format|
      if @post.save!
        format.js
      end
    end
  end

  def edit_locale
    @user = User.find(params[:id]) if params[:id]
    @available_locales = I18n.available_locales.map(&:to_s).collect{ |u| [locale_translate(u), u] }
  end

  def change_locale
    @user = User.find(params[:id]) if params[:id]
    if @user and @user == current_user and params[:set_locale]
      @user.update_attributes(locale: params[:set_locale]) if I18n.available_locales.map(&:to_s).include?(params[:set_locale])
    end
    format.js { head :no_content }
  end

  private
  def set_user
    @user = User.find(params[:id]) if params[:id]
  end

  def correct_user
    redirect_to(root_path) unless current_user?(@user)
  end
end
