class Essay::PostsController < PostsController
  def current_model
    Essay::Post
  end

  def comment_model
    Essay::Comment
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
    @journals = Journal.events_for_user_feed @project.id
    @stage = params[:stage]
  end

  def index
    if @stage == '1' and @project.status == 2 and (@project.stage1.to_i - current_user.voted_aspects.by_project(@project).size) != 0
      redirect_to life_tape_posts_path(@project, action: 'vote_list')
      return
    elsif @stage == '2' and @project.status == 6 and !@project.get_united_posts_for_vote(current_user).empty?
      redirect_to discontent_posts_path(@project, action: 'vote_list')
      return
    elsif @stage == '3' and @project.status == 8 and view_context.get_concept_posts_for_vote?(@project)
      redirect_to concept_posts_path(@project, action: 'vote_list')
      return
    elsif @stage == '5' and @project.status == 11 and current_user.plan_post_votings.size == 0
      redirect_to estimate_posts_path(@project, action: 'vote_list')
      return
    end
    @posts = Essay::Post.where(project_id: @project, stage: @stage, status: 0)
    respond_to do |format|
      format.html
    end
  end
end
