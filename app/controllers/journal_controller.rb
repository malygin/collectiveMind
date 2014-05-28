class JournalController < ApplicationController

  def index
    @project = Core::Project.find(params[:project])
    @my_jounals = Journal.count_events_for_my_feed(@project.id, current_user)
    @journals = Journal.events_for_user_feed(@project.id)

    # @news = ExpertNews::Post.where(:project_id => @project).first
    @journals_feed = Journal.events_for_user_feed(@project.id).paginate(:page => params[:page])
    render 'index', :layout => 'application_two_column'

  end
end
