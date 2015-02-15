class JournalController < ApplicationController
  before_filter :authenticate_user!
  before_filter :have_project_access
  before_filter :user_projects

  def index
    @project = Core::Project.find(params[:project])
    events = Journal.events_for_my_feed @project.id, current_user.id
    g = events.group_by { |e| e.first_id }
    @my_journals=g.collect { |k, v| [v.first, v.size] }
    @my_journals_count = @my_journals.size

    @journals_feed = Journal.events_for_user_feed(@project.id).paginate(page: params[:page])
    @j_count = {today:0, yesterday:0, older:0}
    # @journals_feed_today = @journals_feed.today
    # @journals_feed_yesterday = @journals_feed.yesterday
    # @journals_feed_older = @journals_feed.older
  end
end
