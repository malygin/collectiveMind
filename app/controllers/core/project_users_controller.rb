class Core::ProjectUsersController < ProjectsController
  before_action :journal_data, only: [:user_analytics, :moderator_analytics, :show]
  before_filter :news_data

  def show
  end

  def create
    @project = Core::Project.find(params[:project])
    @user = User.find(params[:user])
    @user.core_project_users.create(project_id: @project.id) unless @user.core_project_users.by_project(@project.id).first
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @user = User.find(params[:user])
    @user.core_project_users.where(project_id: @project.id).destroy_all
    respond_to do |format|
      format.js
    end
  end

  def user_analytics
    redirect_to(root_path) unless prime_admin? || role_expert?
    @count_people = @project.count_people.to_json
    @average_time = @project.average_time.to_json
    @count_pages = @project.count_pages
    @count_actions = @project.count_actions('not_moderators')
  end

  def moderator_analytics
    @count_people = @project.count_people('for_moderators').to_json
    @average_time = @project.average_time('for_moderators').to_json
    @count_pages = @project.count_pages('for_moderators')
    @count_actions = @project.count_actions
    render action: :user_analytics
  end

  def ready_to_concept
    current_user.project_user_for(@project).update ready_to_concept: true
    render json: { head: :ok }
  end
end
