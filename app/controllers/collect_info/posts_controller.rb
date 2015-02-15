class CollectInfo::PostsController < PostsController
  def voting_model
    Core::Aspect
  end

  def prepare_data
    @aspects = @project.aspects
  end

  def index
    return redirect_to action: 'vote_list' if current_user.can_vote_for(:collect_info, @project)
    @aspect = params[:asp] ? Core::Aspect.find(params[:asp]) : @project.aspects.order(:id).first
    @count_aspects = @project.main_aspects.count
    @count_aspects_check = 0
    @project.main_aspects.each do |asp|
      @count_aspects_check += 1 if asp.question_complete(@project, current_user).count == asp.questions.by_project(@project.id).by_status(0).count
    end
  end

  # def vote_list
  #   return redirect_to action: 'index' unless current_user.can_vote_for(:collect_info, @project)
  #   @posts = voting_model.scope_vote_top(@project.id, params[:revers])
  #   @path_for_voting = "/project/#{@project.id}/collect_info/"
  #   @votes = @project.stage1_count
  #   @number_v = @project.get_free_votes_for(current_user, 'lifetape')
  #   respond_to do |format|
  #     format.html
  #     format.js
  #   end
  # end
  #
  # def to_archive
  #   super()
  #   @post.user.add_score(type: :to_archive_life_tape_post)
  # end
  #
  # #@todo перевод аспекта в дополнительные и обратно при голосовании
  # def set_aspect_status
  #   @post = voting_model.find(params[:id])
  #   @post.toggle!(:status)
  #   respond_to do |format|
  #     format.js
  #   end
  # end
  #
  # def vote_result
  #   @posts = voting_model.scope_vote_top(@project.id, params[:revers])
  # end
end
