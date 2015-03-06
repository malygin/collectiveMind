class Core::AspectsController < ProjectsController
  before_action :prepare_data, except: [:update, :destroy]
  before_action :set_aspect, except: [:new, :create]

  def new
    @aspect = Core::Aspect.new
  end

  def create
    @aspect = @project.aspects.create core_aspect_params
    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def update
    @aspect.update_attributes core_aspect_params
  end

  def destroy
    @aspect.destroy if boss?
    redirect_back_or life_tape_posts_path
  end

  def answer_question
    @aspect = params[:id] ? Core::Aspect.find(params[:id]) : @project.aspects.order(:id).first
    @question = CollectInfo::Question.find(params[:question_id])
    aspect_questions = @aspect.questions.by_project(@project).by_status(0).order("collect_info_questions.id")
    @uncorrect_answers = @question.answers.by_status(0).by_uncorrect.pluck("collect_info_answers.id")
    @correct_answers = @question.answers.by_status(0).by_correct.pluck("collect_info_answers.id")
    if params[:answers]
      # params[:answers].each do |answer|
      #   @wrong_answer = true if @uncorrect_answers.include? answer.to_i
      # end
      # params[:answers].each do |answer|
      #   @wrong_answer = true unless @correct_answers.include? answer.to_i
      # end
      arr = params[:answers].collect{|a| a.to_i} - @correct_answers
      @wrong_answer = true if arr.present?

      unless @wrong_answer
        if params[:answers]
          params[:answers].each do |answer|
            current_user.user_answers.create(answer_id: answer.to_i, project_id: @project.id, question_id: @question.id)
          end
        end
        @next_question = aspect_questions[(aspect_questions.index @question) + 1]
        @count_now = @aspect.question_complete(@project, current_user).count
        @count_all = @aspect.questions.by_project(@project).by_status(0).count
        unless @next_question
          @count_aspects = @project.main_aspects.count
          @count_aspects_check = 0
          @project.main_aspects.each do |asp|
            @count_aspects_check += 1 if asp.question_complete(@project, current_user).count == asp.questions.by_project(@project).by_status(0).count
          end
        end
      end
    end
  end

  private
  def set_aspect
    @aspect = Core::Aspect.find(params[:id])
  end

  def core_aspect_params
    params.require(:core_aspect).permit(:content, :position, :core_aspect_id, :short_desc, :status, :short_name, :color)
  end

  def prepare_data
    @aspects = Core::Aspect.where(project_id: @project)
  end
end
