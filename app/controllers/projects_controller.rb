##
# Контроллер, который является родительским для всех, которые находятся внутри scope '/project/:project'
# Гарантирует, что будет доступен объект проекта: @project
# Гарантирует, что только пользователи, имеющие доступ к проекту, пройдут дальше
class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_project
  before_filter :check_access_to_project

  protected
  def set_project
    @project = Core::Project.find(params[:project])
  end

  def journal_data
    @my_journals = current_user.my_journals @project
    @my_journals_count = @my_journals.size
  end

  def news_data
    @expert_news = @project.news
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
