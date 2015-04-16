class Core::Essay::PostsController < PostsController
  def prepare_data
    @journals = Journal.events_for_user_feed @project.id
    @stage = params[:stage]
  end

  def index
    if @stage == '1' and @project.status == 2 and current_user.can_vote_for(:collect_info, @project)
      redirect_to collect_info_posts_path(@project)
      return
    elsif @stage == '2' and @project.status == 6 and current_user.can_vote_for(:discontent, @project)
      redirect_to discontent_posts_path(@project)
      return
    elsif @stage == '3' and @project.status == 8 and current_user.can_vote_for(:concept, @project)
      redirect_to concept_posts_path(@project)
      return
    elsif @stage == '5' and @project.status == 11 and current_user.can_vote_for(:plan, @project)
      redirect_to estimate_posts_path(@project)
      return
    end
    @posts = Core::Essay::Post.where(project_id: @project, stage: @stage, status: 0)
    respond_to do |format|
      format.html
    end
  end
end