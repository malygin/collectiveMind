class LifeTape::PostsController < PostsController
  def current_model
    LifeTape::Post
  end

  def voting_model
    Discontent::Aspect
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
    @aspects = Discontent::Aspect.where(project_id: @project)
  end

  def index
    return redirect_to action: 'vote_list' if current_user.can_vote_for(:life_tape, @project)
    @page = params[:page]
    @aspect = params[:asp] ? Discontent::Aspect.find(params[:asp]) : @project.aspects.order(:id).first
    @post_show = @aspect.life_tape_post unless @aspect.nil?
    @comments= @post_show.main_comments.paginate(page: @page ? @page : last_page, per_page: 10).includes(:comments) if @post_show
    @comment = LifeTape::Comment.new
  end

  def vote_list
    return redirect_to action: 'index' unless current_user.can_vote_for(:life_tape, @project)
    @posts = voting_model.scope_vote_top(@project.id, params[:revers])
    @path_for_voting = "/project/#{@project.id}/life_tape/"
    @votes = @project.stage1_count
    @number_v = @project.get_free_votes_for(current_user, 'lifetape')
    respond_to do |format|
      format.html
      format.js
    end
  end

  #@todo перенос комментов(вместе с ответами) между темами
  def transfer_comment
    @project = Core::Project.find(params[:project])
    aspect = Discontent::Aspect.find(params[:aspect_id])
    post = aspect.life_tape_post
    @comment = LifeTape::Comment.find(params[:comment_id])
    aspect_old = @comment.post.discontent_aspects.first
    unless post.nil?
      @comment.update_attributes(post_id: post.id)
      unless @comment.comments.nil?
        @comment.comments.each do |c|
          c.update_attributes(post_id: post.id)
        end
      end
      #корректировка ссылок в новостях
      Journal.events_for_transfer_comment(@project, @comment, aspect_old.id, aspect.id)
    end
    respond_to do |format|
      format.js
    end
  end

  def to_archive
    super()
    @post.user.add_score(type: :to_archive_life_tape_post)
  end

  #@todo перевод аспекта в дополнительные и обратно при голосовании
  def set_aspect_status
    @post = voting_model.find(params[:id])
    @post.toggle!(:status)
    respond_to do |format|
      format.js
    end
  end

  def last_page
    total_results = @post_show.main_comments.count
    page = total_results / 10 + (total_results % 10 == 0 ? 0 : 1)
    page == 0 ? 1 : page
  end

  def vote_result
    @project = Core::Project.find(params[:project])
    @posts = voting_model.scope_vote_top(@project.id, params[:revers])
  end

  private
  def life_tape_post_params
    params.require(:life_tape_post).permit(:important, :aspect)
  end

  def life_tape_voiting_params
    params.require(:life_tape_voiting).permit(:user)
  end
end
