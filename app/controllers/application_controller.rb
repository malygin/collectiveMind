class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :start_visit

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def start_visit
    # записываем url без параметров, чтобы проще парсить
    # возможсно стоит разбивать url на составляющие и отдельно записывать
    if current_user and @project and request.method == 'GET'
      current_user.loggers.create type_event: 'visit_save', project_id: @project.id,
                                  body: request.original_url.split('?')[0]
    end
  end
end
