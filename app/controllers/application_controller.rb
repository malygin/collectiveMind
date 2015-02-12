class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_project
  before_action :start_visit
  before_action :set_locale
  # around_action :with_locale

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  def journal_data
    set_project
    @my_journals = current_user.my_journals @project
  end

  def user_projects
    @user_projects = current_user.current_projects_for_ordinary_user if current_user
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end


  def set_locale
    # I18n.load_path += Dir[Rails.root.join('config', 'locales', '*.yml')]
    # I18n.default_locale = extract_locale_from_user
    # I18n.reload!
    I18n.locale = (extract_locale_from_user || I18n.default_locale).to_sym
    I18n.load_path += Dir[Rails.root.join("config/locales/**/*.yml")]
    session[:locale] = I18n.locale
    # I18n.reload!
    # session[:locale] = I18n.locale
    # redirect_to :back
    # I18n.load_path += Dir[Rails.root.join('config', 'locales', "#{I18n.locale}.yml").to_s]
  end

  def with_locale
    I18n.with_locale(params[:locale]) { yield }
  end

  def extract_locale_from_user
    if params[:locale]
      parsed_locale = params[:locale]
    elsif signed_in? and current_user.locale.present?
      parsed_locale = current_user.locale
    else
      parsed_locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def start_visit
    if current_user and @project and request.method == 'GET'
      current_user.journals.create type_event: 'visit_save', project_id: @project.id,
                                   body: request.original_url
    end
  end

  def set_project
    @project = Core::Project.find params[:project] if params[:project]
  end
end
