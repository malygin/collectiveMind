##
# parent controller for scope '/project/:project'
# guarantee  @project is available
# guarantee secure project only for coorect users
class ProjectsController < ApplicationController
  before_action :set_project
  before_filter :check_access_to_project
  before_filter :news_data, only: [:index, :new, :edit, :show, :user_content]
  before_filter :journal_data, only: [:index, :new, :edit, :show, :user_content]

  # base logging, works after for proper date
  after_action :start_visit

  protected

  def set_project
    @project = ProjectDecorator.new Core::Project.find(params[:project])
  end

  def journal_data
    @my_journals = current_user.my_journals(@project)
    @my_journals_count = @my_journals.size
    return unless @my_journals_count == 0
    @my_journals = current_user.my_journals_viewed @project
  end

  def check_access_to_project
    return if current_user && @project.users.include?(current_user)
    redirect_to root_url
  end

  def start_visit
    # record url without params for easy parsing
    return unless current_user && @project && request.method == 'GET'
    current_user.loggers.create type_event: 'visit_save', project_id: @project.id,
                                body: request.original_fullpath.split('?')[0], request_format: request.format.to_sym
  end

  def news_data
    @expert_news = @project.news
  end
end
