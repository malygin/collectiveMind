class UsersController < ProjectsController
  before_action :set_user
  before_filter :correct_user, only: [:update]
  before_filter :journal_data, only: [:index, :new, :show,  :journal_clear, :edit_notice]

  def index
    @users = @project.users.where(users: { type_user: 0 })
  end

  def show
    redirect_to polymorphic_path(@project.current_stage_type, project: @project, action: :user_content, edit_profile: true) if @user == current_user
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
    flash[:success] = 'Профиль обновлен' if @user.update_attributes(to_update)
    respond_to :js
  end

  # clean notifications
  def journal_clear
    if @my_journals.size > 0 && current_user?(@user)
      Journal.events_for_my_feed(@project.id, current_user).update_all(viewed: true)
      journal_data
    end
    respond_to :js
  end

  # :nocov:
  def search
    @code = params[:code]
    @search_users = User.search params[:search_users_text]
  end

  # mail sender
  def edit_notice
    @auto_feed_mailer = current_user.user_checks.where(project_id: @project.id, check_field: 'auto_feed_mailer').first
    @journal_mailer = JournalMailer.new
    @mailers = boss? ? @project.journal_mailers : @project.journal_mailers.mailers_for_moderator(current_user)
  end

  def create_notice
    @post = @project.journal_mailers.build(params[:journal_mailer])
    @post.user = current_user
    @post.project = @project
    @post.status = 0
    @post.save
    respond_to :js
  end
  # :nocov:

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
