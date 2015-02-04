class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_project
  before_action :start_visit

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  def journal_data
    @project = Core::Project.find(params[:project])
    @my_journals = current_user.my_journals @project
  end

  def user_projects
    @user_projects = current_user.current_projects_for_ordinary_user if current_user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def start_visit
    if current_user and @project
      j = current_user.journals.create type_event: 'visit_save', project_id: @project.id,
                                   body:  request.original_url
      p "========#{j.id}, #{j.created_at}"
    end
  end

  def set_project
    @project = Core::Project.find params[:project] if params[:project]
  end
end
