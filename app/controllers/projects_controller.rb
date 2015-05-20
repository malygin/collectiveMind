##
# Контроллер, который является родительским для всех, которые находятся внутри scope '/project/:project'
# Гарантирует, что будет доступен объект проекта: @project
# Гарантирует, что только пользователи, имеющие доступ к проекту, пройдут дальше
class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_project
  before_filter :check_access_to_project
  before_filter :news_data
  # базовое логирование, отрабатывает после, чтобы дата была предпоследней
  after_action :start_visit

  protected
  def set_project
    @project = Core::Project.find(params[:project])
  end

  def journal_data
    @my_journals = current_user.my_journals @project
    @my_journals_count = @my_journals.size
    if @my_journals_count == 0
      @my_journals = current_user.my_journals_viewed @project
    end
  end

  def check_access_to_project
    unless @project.users.include?(current_user) or prime_admin?
      redirect_to root_url
    end
  end
end
