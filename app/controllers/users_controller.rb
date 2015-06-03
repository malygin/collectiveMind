class UsersController < ProjectsController
  before_action :set_user
  before_filter :correct_user, only: [:update]
  before_filter :journal_data, only: [:index, :new, :show,  :journal_clear, :edit_notice]

  def index
    @users = @project.users_in_project.where(users: {type_user: 0})
  end

  def new
    @user = User.new
    @title = 'Sign up'
  end

  def show
    redirect_to polymorphic_path(@project.current_stage_type, project: @project, action: :user_content, edit_profile: true) if @user == current_user
    # if @user != current_user
    #   @journals = Journal.events_for_user_show @project.id, @user.id, 30
    # else
    #   @journals = Journal.events_for_user_show @project.id, @user.id, 30
    # end
  end

  def update
    # params[:user].delete(:password) if params[:user][:password].blank?
    to_update = user_params
    to_update.delete(:password) if to_update[:password].blank?
    to_update.delete(:password_confirmation) if to_update[:password].blank?
    if params[:user][:avatar].present?
      img = Cloudinary::Uploader.upload(params[:user][:avatar], folder: 'avatars', width: 600, height: 600, crop: :limit)
      to_update.merge!(avatar: img['public_id'])
    end
    if @user.update_attributes(to_update)
      flash[:success] = 'Профиль обновлен'
    end
    # redirect_to user_path(@project, @user)
    # respond_to do |format|
    #   if @user.update_attributes(to_update)
    #     format.html { redirect_to user_path(@project, @user) }
    #     format.js
    #   end
    # end
    respond_to do |format|
      format.html { redirect_to user_path(@project, @user) }
      format.js
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'Пользователь удален!!'
    redirect_to users_path
  end

  #clean notifications
  def journal_clear
    if @my_journals.size > 0 && current_user?(@user)
      Journal.events_for_my_feed(@project.id, current_user).update_all(viewed: true)
      journal_data
    end
    respond_to :js
  end

  def search
    @code = params[:code]
    @search_users = User.search params[:search_users_text]
  end

  def update_score
    params[:value] = '0' if params[:value] == ''
    respond_to do |format|
      if @user.update_attributes(params[:name] => params[:value])
        format.json { head :no_content } # 204 No Content
        format.js { head :no_content }
      end
    end
  end


  #mail sender
  def edit_notice
    @auto_feed_mailer = current_user.user_checks.where(project_id: @project.id, check_field: 'auto_feed_mailer').first
    @journal_mailer = JournalMailer.new
    @mailers = prime_admin? ? @project.journal_mailers : @project.journal_mailers.mailers_for_moderator(current_user)
  end

  def create_notice
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

  private
  def set_user
    @user = User.find(params[:id]) if params[:id]
  end

  def correct_user
    redirect_to(root_path) unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:name, :surname, :email, :skype, :phone, :password, :password_confirmation)
  end
end
