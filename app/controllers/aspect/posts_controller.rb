class Aspect::PostsController < PostsController
  before_action :set_aspect, only: [:edit, :update, :destroy]
  before_action :user_vote, only: [:index]

  def index
    @main_aspects = @project.get_main_aspects_sorted_by params[:sort_rule]
    @other_aspects = @project.get_other_aspects_sorted_by params[:sort_rule]
    @questions_progress, @questions_progress_all = aspect_answers_count(@project)
    @presenter = LastVisitPresenter.new(project: @project, controller: params[:controller], user: current_user)
    @project_result = ProjectResulter.new @project unless @project.can_add?(params[:controller])
    respond_to :html
  end

  def answer_question
    @aspect = Aspect::Post.find(params[:id])
    @question = Aspect::Question.find(params[:question_id])
    @right_answer = @question.answer_from_type(current_user, params[:answers], params[:content], params[:skip])
    @questions_progress, @questions_progress_all = aspect_answers_count(@project)
  end

  def new
    @aspect = Aspect::Post.new
  end

  def create
    @aspect = @project.aspects.create aspect_params.merge(user: current_user, status: 1)
    respond_to :js
  end

  def edit
    render action: :new
  end

  def update
    @aspect.update_attributes aspect_params
  end

  def destroy
    @aspect.destroy if current_user?(@aspect.user)
    redirect_back_or user_content_aspect_posts_path(@project)
  end

  private

  def set_aspect
    @aspect = Aspect::Post.find(params[:id])
  end

  def aspect_params
    params.require(:aspect_post).permit(:content, :position, :aspect_id, :short_desc, :status, :short_name, :color, :detailed_description)
  end
end
