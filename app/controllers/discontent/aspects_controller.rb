class Discontent::AspectsController < ProjectsController
  before_action :prepare_data, except: [:update, :destroy]
  before_action :set_aspect, except: [:new, :create]

  def new
    @aspect = Discontent::Aspect.new
  end

  def create
    @aspect = @project.aspects.create discontent_aspect_params
    @post = @aspect.life_posts.build(status: 0, project: @project)
    @aspect.life_tape_posts << @post
    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def update
    @aspect.update_attributes discontent_aspect_params
  end

  def destroy
    @aspect.destroy if boss?
    redirect_back_or life_tape_posts_path
  end

  def answer_question
    @question = Question.find(params[:question_id])
    aspect_questions = @aspect.questions.by_project(@project.id).by_status(0).order("questions.id")
    @answers = @question.answers.by_status(0).by_style(0).pluck("answers.id")
    if params[:answers]
      params[:answers].each do |answer|
        @wrong_answer = true if @answers.include? answer.to_i
      end
    end
    unless @wrong_answer
      if params[:answers]
        params[:answers].each do |answer|
          current_user.answers_users.create(answer_id: answer.to_i, project_id: @project.id, question_id: @question.id)
        end
      end
      @next_question = aspect_questions[(aspect_questions.index @question) + 1]
      @count_now = @aspect.question_complete(@project, current_user).count
      @count_all = @aspect.questions.by_project(@project.id).by_status(0).count
      unless @next_question
        @count_aspects = @project.aspects.main_aspects.count
        @count_aspects_check = 0
        @project.aspects.main_aspects.each do |asp|
          @count_aspects_check += 1 if asp.question_complete(@project, current_user).count == asp.questions.by_project(@project.id).by_status(0).count
        end
      end
    end
  end

  private
  def set_aspect
    @aspect = Discontent::Aspect.find(params[:id])
  end

  def discontent_aspect_params
    params.require(:discontent_aspect).permit(:content, :position, :discontent_aspect_id, :short_desc, :status, :short_name, :color)
  end

  def prepare_data
    @aspects = Discontent::Aspect.where(project_id: @project)
  end
end
