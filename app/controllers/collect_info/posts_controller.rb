class CollectInfo::PostsController < PostsController
  before_action :set_aspects, only: [:index]

  def voting_model
    Core::Aspect::Post
  end

  def current_model
    Core::Aspect::Post
  end

  def comment_model
    Core::Aspect::Comment
  end

  def index
    # @proc_aspects = @project.proc_main_aspects
    @proc_aspects = @project.get_main_aspects_sorted_by params[:sort_rule]
    @other_aspects = @project.get_other_aspects_sorted_by params[:sort_rule]
    @questions_progress, @questions_progress_all = collect_info_answers_count(@project)
    @user_voter = UserDecorator.new current_user if current_user.can_vote_for(:collect_info, @project)
    @project_result = ProjectDecorator.new @project unless @project.stage == '1:0' || @project.stage == '1:1'
    respond_to :html
  end

  def answer_question
    @aspect = Core::Aspect::Post.find(params[:id])
    @question = CollectInfo::Question.find(params[:question_id])
    @wrong = @question.answer_from_type(@project, @aspect, current_user, params[:answers], params[:content], params[:skip])
    @questions_progress, @questions_progress_all  = collect_info_answers_count(@project)
  end

  private

  def set_aspects
    @aspects = @project.main_aspects
  end
end
