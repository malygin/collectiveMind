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
    # @todo REF move check in model and more comments daniil
    @count_aspects_check = 0
    @project.main_aspects.each do |asp|
      if asp.question_complete(current_user).count == asp.questions.by_status(0).count
        @count_aspects_check += 1
      end
    end

  end

  def render_slider
  end

  # @todo REF catastrophe
  def answer_question
    @aspect = params[:id] ? Core::Aspect.find(params[:id]) : @project.main_aspects.first
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
      arr = params[:answers].collect { |a| a.to_i } - @correct_answers
      arr2 = @correct_answers - params[:answers].collect { |a| a.to_i }
      @wrong_answer = true if arr.present? or arr2.present?

      unless @wrong_answer
        if params[:answers]
          params[:answers].each do |answer|
            current_user.user_answers.create(answer_id: answer.to_i, project_id: @project.id, question_id: @question.id, aspect_id: @aspect.id).save!
          end
        end
        @next_question = aspect_questions[(aspect_questions.index @question) + 1]
        @count_now = @aspect.question_complete(@project, current_user).count
        @count_all = @aspect.questions.by_project(@project).by_status(0).count
        # unless @next_question
        @count_aspects = @project.main_aspects.count
        @count_aspects_check = 0
        @project.main_aspects.each do |asp|
          @count_aspects_check += 1 if asp.question_complete(@project, current_user).count == asp.questions.by_project(@project).by_status(0).count
        end
        # end
      end
    end
  end

  private

  def set_aspects
    # @todo выбираем только аспекты первого уровня (без вложенности)
    @aspects = @project.main_aspects
  end
end
