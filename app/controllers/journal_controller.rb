class JournalController < ProjectsController
  before_filter :have_project_access

  def index
    @journals_feed = Journal.events_for_user_feed(@project.id).paginate(page: params[:page])
    @j_count = {today: 0, yesterday: 0, older: 0}
  end
end
