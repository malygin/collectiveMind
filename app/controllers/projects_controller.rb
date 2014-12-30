class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_project
  before_action :user_projects
  before_filter :check_access_to_project

  protected
  def set_project
    @project = Core::Project.find(params[:project]) if params[:project].present?
  end

  def journal_data
    @my_journals = current_user.my_journals @project
    @my_journals_count = @my_journals.size
  end

  def user_projects
    @user_projects = current_user.current_projects_for_ordinary_user if current_user
  end

  def check_access_to_project
    if %w(lifetape_posts discontent_posts concept_posts plan_posts estimate_posts essay_posts).include? params[:controller]
      # @todo Рефакторинг model_min_stage
      if @project.status < @project.model_min_stage(current_model.table_name.singularize)
        redirect_to polymorphic_path(@project.redirect_to_current_stage)
      end
    end

    unless @project.users.include?(current_user) or prime_admin?
      redirect_back_or root_url
    end
  end
end
