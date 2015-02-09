class Core::ProjectUsersController < ApplicationController
  before_action :set_project
  before_action :journal_data, only: [:user_analytics, :moderator_analytics]
  layout 'application'

  def user_analytics
    #@todo check not for current_user, but for have access to analytic
    redirect_to(root_path) unless prime_admin? or current_user
    @count_people = @project.count_people.to_json
    @average_time = @project.average_time.to_json
    @count_pages = @project.count_pages
    @count_actions = @project.count_actions('not_moderators')
  end

  def moderator_analytics
    prime_admin_authenticate
    @count_people = @project.count_people('for_moderators').to_json
    @average_time = @project.average_time('for_moderators').to_json
    @count_pages = @project.count_pages('for_moderators')
    @count_actions = @project.count_actions
    render action: :user_analytics
  end

  private
  def set_project
    @project = Core::Project.find(params[:project]) if params[:project]
  end
end
