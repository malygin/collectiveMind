class JournalController < ApplicationController

  def index
    @project = Core::Project.find(params[:project])
    events  = Journal.events_for_my_feed @project.id, current_user.id
    g = events.group_by { |e| e.first_id }
    @my_journals=g.collect{|k,v| [v.first, v.size]}
    @my_journals_count = @my_journals.size

    @journals_feed = Journal.events_for_user_feed(@project.id).paginate(:page => params[:page])
    render 'index', :layout => 'application_two_column'

  end
end
