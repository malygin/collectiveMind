class JournalController < ProjectsController
  before_filter :have_project_access

  def index
    @journals_feed = Journal.events_for_user_feed(@project.id).paginate(page: params[:page])
    @j_count = {today: 0, yesterday: 0, older: 0}
    # @journals_feed_today = @journals_feed.today
    # @journals_feed_yesterday = @journals_feed.yesterday
    # @journals_feed_older = @journals_feed.older
  end
end
