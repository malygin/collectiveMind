class JournalController < ApplicationController

  def index
    @project = Core::Project.find(params[:project])

    # @news = ExpertNews::Post.where(:project_id => @project).first
    @journals = Journal.where(:project_id => params[:project]).order('created_at DESC').paginate(:page => params[:page])
    render 'index', :layout => 'application_two_column'

  end
end
