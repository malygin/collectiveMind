class ProjectsController < ApplicationController
  # @todo REF we have 3 same query to coreProjects model, whyy?
  before_filter :authenticate_user!
  before_action :set_project
  before_filter :check_access_to_project

  protected
  def set_project
    @project = Core::Project.find(params[:project]) if params[:project].present?
  end

  def journal_data
    @my_journals = current_user.my_journals @project
    @my_journals_count = @my_journals.size
  end

  def check_access_to_project
    if Core::Project::LIST_STAGES.map { |key, hash| hash[:type_stage] }.include? params[:controller].gsub('/', '_').to_sym
      # @todo Рефакторинг model_min_stage
      if @project.status < @project.model_min_stage(current_model.table_name.singularize)
        redirect_to polymorphic_path(@project.current_stage_type)
      end
    end

    unless @project.users.include?(current_user) or prime_admin?
      redirect_to root_url
    end
  end
end
