# encoding: utf-8
class UsersController < ApplicationController
	layout 'application_two_column'
	#before_filter :authenticate, :only => [:edit, :update, :show]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user, :only => [:destroy]
  before_filter :journal_data, :only => [:index, :new, :edit, :show, :users_rc]
  before_filter :admin_authenticate, :only => [:list_users,:add_user_for_project,:remove_user_for_project]
	def new
		@user = User.new
		@title = "Sign up"
	end

	def show
    @user = User.find(params[:id])
    @project = Core::Project.find(params[:project])
    @awards = Award.all
    add_breadcrumb  @user, user_path(@project, @user)

    if @user != current_user
     @journals = Journal.events_for_user_show @project.id, @user.id, 30
    else
      @journals = Journal.events_for_user_show @project.id, @user.id, 30
    end
    if @my_journals_count > 0 and @user == current_user
      Journal.events_for_my_feed(@project.id, current_user).update_all(viewed: true)
    end
  end

	def edit
    @user = User.find(params[:id])
    add_breadcrumb  "Редактирование профиля: #{@user}", edit_user_path(@project, @user)
  end

	def index
    @project = Core::Project.find(params[:project])
    add_breadcrumb I18n.t('menu.raiting'), users_path(@project)
    @users = User.joins(:core_project_scores).where("core_project_scores.project_id = ? AND core_project_scores.score > 0", @project.id).where(:users => {:type_user => [4,5,7,8,nil]}).order("core_project_scores.score DESC").paginate(:page =>params[:page])
  end

  def show_top
    @project = Core::Project.find(params[:project])
    @users = User.joins(:core_project_scores).where("core_project_scores.project_id = ? AND core_project_scores.score > 0", @project.id).where(:users => {:type_user => [4,5,7,8,nil]}).order("core_project_scores.#{params[:score_name]} DESC").paginate(:page =>params[:page])
    @score_name = params[:score_name]
    respond_to do |format|
      format.js
    end
  end

  def users_rc
    @project = Core::Project.find(params[:project])
    @users = User.where(:type_user => [4,7]).order('score DESC').paginate(:page =>params[:page])
  end

  def list_users
    @project = Core::Project.find(params[:project])
    @users = User.paginate(:page =>params[:page])
    respond_to do |format|
      format.html { render :layout => 'core/list_projects'}
    end
  end

  def add_user_for_project
    @project = Core::Project.find(params[:project])
    @user = User.find(params[:id])
    @user.core_project_users.create(:project_id => @project.id)
    respond_to do |format|
      format.js
    end
  end

  def remove_user_for_project
    @project = Core::Project.find(params[:project])
    @user = User.find(params[:id])
    @user.core_project_users.where(:project_id => @project.id).destroy_all
    respond_to do |format|
      format.js
    end
  end

  def update_score
    @project = Core::Project.find(params[:project])
    @user = User.find(params[:id])
    params[:value] = "0" if params[:value] == ""
    respond_to do |format|
      if @user.update_attributes(params[:name] => params[:value])
        format.json { head :no_content } # 204 No Content
        format.js { head :no_content }
      end
    end
  end

  def club_toggle
    @project = Core::Project.find(params[:project])
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes!(:type_user => view_context.club_toggle_user(@user))
        format.js
      end
    end
  end

	def update
    @project = Core::Project.find(params[:project])
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
		if @user.update_attributes(params[:user])
			flash[:success] = "Профиль обновлен"
			redirect_to user_path(@project,@user)
		else
			render 'edit'
		end
	end


	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "Пользователь удален!!"
		redirect_to users_path
	end

	def add_score
		user = User.find(params[:id])
		if boss?
      @project = Core::Project.find(params[:project])
      user.add_score_by_type(@project, params[:score].to_i, :score_a)
      user.journals.build(:type_event=>'add_score', :project => @project, :body=>params[:score]).save
      current_user.journals.build(:type_event=>'my_add_score', :user_informed => user, :project => @project, :body=>params[:score], :viewed=> false).save!
    end
    respond_to do |format|
      format.js
    end
  end

	def add_score_essay
		user = User.find(params[:id])
		if boss?
      @project = Core::Project.find(params[:project])
      user.journals.build(:type_event=>'add_score_essay', :project => @project, :body=>params[:score]).save
    end
		render json: user.score
	end

	private

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

end

