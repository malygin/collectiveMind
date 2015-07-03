class Aspect::PostsController < PostsController
  before_action :prepare_data, except: [:update, :destroy]
  before_action :set_aspect, only: [:edit, :update, :destroy]
  before_action :set_aspects, only: [:index]
  before_action :user_vote, only: [:index]

  def voting_model
    Aspect::Post
  end

  def current_model
    Aspect::Post
  end

  def index
    @main_aspects = @project.get_main_aspects_sorted_by params[:sort_rule]
    @other_aspects = @project.get_other_aspects_sorted_by params[:sort_rule]
    @questions_progress, @questions_progress_all = aspect_answers_count(@project)
    @project_result = ProjectDecorator.new @project unless @project.stage == '1:0' || @project.stage == '1:1'
    respond_to :html
  end

  def answer_question
    @aspect = Aspect::Post.find(params[:id])
    @question = Aspect::Question.find(params[:question_id])
    @right_answer = @question.answer_from_type(current_user, params[:answers], params[:content], params[:skip], @project.type_for_questions)
    @questions_progress, @questions_progress_all  = aspect_answers_count(@project)
  end

  def new
    @aspect = Aspect::Post.new
  end

  def create
    @aspect = @project.aspects.create aspect_params.merge(user: current_user, status: 1)
    respond_to do |format|
      format.js
    end
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

  def set_aspects
    @aspects = @project.aspects_for_discussion
  end

  def aspect_params
    params.require(:aspect_post).permit(:content, :position, :aspect_id, :short_desc, :status, :short_name, :color, :detailed_description)
  end

  def prepare_data
    @aspects = Aspect::Post.where(project_id: @project)
  end
end
