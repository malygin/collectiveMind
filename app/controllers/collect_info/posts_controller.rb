class CollectInfo::PostsController < PostsController
  before_action :set_aspects, only: [:index, :render_slider]

  def voting_model
    Core::Aspect
  end

  def current_model
    Core::Aspect
  end

  def index
    @aspect = params[:asp] ? Core::Aspect.find(params[:asp]) : @project.main_aspects.first
    @count_aspects = @project.main_aspects.count

    # @count_aspects_check = @project
    # @project.main_aspects.each do |asp|
    #   if asp.question_complete(current_user).count == asp.questions.by_status(0).count
    #     @count_aspects_check += 1
    #   end
    # end

  end

  def render_slider
  end

  def answer_question
    @aspect = Core::Aspect.find(params[:id])
    @question = CollectInfo::Question.find(params[:question_id])
    @wrong_answers = @question.answers.by_wrong.pluck("collect_info_answers.id")
    @correct_answers = @question.answers.by_correct.pluck("collect_info_answers.id")
    if params[:answers]
      #проверка правильности набора ответов
      answers = params[:answers].collect { |a| a.to_i }
      @wrong = true if (answers - @correct_answers).present? or (@correct_answers - answers).present?
      unless @wrong
        current_user.user_answers.create(project_id: @project.id, question_id: @question.id, aspect_id: @aspect.id).save!
        # подсчет данных для прогресс-бара по вопросам
        count_all = CollectInfo::Question.joins(:core_aspect).where('core_aspects.project_id' => @project).count
        count_answered = CollectInfo::UserAnswers.select(' DISTINCT "collect_info_user_answers"."question_id" ').joins(:aspect).where('core_aspects.project_id' => @project).where(user: current_user).count
        @questions_progress = (count_answered.to_f/count_all.to_f) * 100
      end
    end
  end

  private

  def set_aspects
    # @todo выбираем только аспекты первого уровня (без вложенности)
    @aspects = @project.main_aspects
  end
end
