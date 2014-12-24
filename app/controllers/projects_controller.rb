class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_project

  protected
  def set_project
    @project = Core::Project.find(params[:project]) if params[:project].present?
  end

  def journal_data
    @my_journals = current_user.my_journals @project
  end

  def user_projects
    @user_projects = current_user.current_projects_for_ordinary_user if current_user
  end
end
