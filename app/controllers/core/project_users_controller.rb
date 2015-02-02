class Core::ProjectUsersController < ApplicationController
  before_filter :prime_admin_authenticate
  before_action :set_project
  before_action :journal_data, only: [:user_analytics, :moderator_analytics]
  layout 'application'

  def user_analytics
    @count_people = @project.count_people.to_json
    @average_time = @project.average_time.to_json
  end

  def moderator_analytics
    @count_people = @project.count_people('for_moderators').to_json
    @average_time = @project.average_time('for_moderators').to_json
  end

  private
  def set_project
    @project = Core::Project.find(params[:project]) if params[:project]
  end
end
