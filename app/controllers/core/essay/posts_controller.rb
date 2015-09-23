class Core::Essay::PostsController < PostsController
  def prepare_data
    @journals = Journal.events_for_user_feed @project.id
    @stage = params[:stage]
  end

  def index
    @posts = Core::Essay::Post.where(project_id: @project, stage: @stage, status: 0)
    respond_to do |format|
      format.html
    end
  end
end
