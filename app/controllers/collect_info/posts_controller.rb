class CollectInfo::PostsController < PostsController
  before_action :set_aspects, only: [:index, :render_slider]

  def voting_model
    Core::Aspect::Post
  end

  def current_model
    Core::Aspect::Post
  end

  def index
    # @aspect = params[:asp] ? Core::Aspect::Post.find(params[:asp]) : @project.main_aspects.first
    @proc_aspects = @project.proc_main_aspects

    if params[:sort_comments]
      @other_aspects = @project.other_main_aspects.sort_comments
    elsif params[:sort_date]
      @other_aspects = @project.other_main_aspects.created_order
    else
      @other_aspects = @project.other_main_aspects
    end

    # подсчет данных для прогресс-бара по вопросам
    # число вопросов по процедуре
    count_all = CollectInfo::Question.by_type(@project.type_for_questions).joins(:core_aspect).where('core_aspect_posts.project_id' => @project).count
    # число вопросов на которые пользователь ответил
    count_answered = CollectInfo::UserAnswers.select(' DISTINCT "collect_info_user_answers"."question_id" ').joins(:question).where(collect_info_questions: {project_id: @project, type_stage: @project.type_for_questions} ).where(collect_info_user_answers: {user_id: current_user}).count
    # прогресс для данного пользователя
    @questions_progress = count_all == 0 ? 0 : (count_answered.to_f/count_all.to_f) * 100

    # общее кол ичество ответов пользователей закрытой процедуры
    if @project.closed?
      count_all = count_all || CollectInfo::Question.by_type(@project.type_for_questions).joins(:core_aspect).where('core_aspect_posts.project_id' => @project).count
      users_count = @project.users_in_project.uniq.count
      count_answered_all = CollectInfo::UserAnswers.select(' DISTINCT "collect_info_user_answers"."question_id" ').joins(:question).where(collect_info_questions: {project_id: @project, type_stage: @project.type_for_questions} ).count
      @questions_progress_all = count_all*users_count == 0 ? 0 : (count_answered_all.to_f/(count_all*users_count).to_f) * 100
    end
  end

  def render_slider
  end



  def answer_question
    @aspect = Core::Aspect::Post.find(params[:id])
    @question = CollectInfo::Question.find(params[:question_id])
    @wrong_answers = @question.answers.by_wrong.pluck("collect_info_answers.id")
    @correct_answers = @question.answers.by_correct.pluck("collect_info_answers.id")
    if params[:answers]
      #проверка правильности набора ответов
      if @project.type_for_questions == 1
        answers = params[:answers].collect { |a| a.to_i }
        @wrong = true if (answers - @correct_answers).present? or (@correct_answers - answers).present?
      end
      unless @wrong
        unless current_user.user_answers.where(project_id: @project.id, question_id: @question.id, aspect_id: @aspect.id).present?
          current_user.user_answers.create(project_id: @project.id, question_id: @question.id, aspect_id: @aspect.id, answer_id: params[:answers].first.to_i, content: params[:content]).save!
        end
        # подсчет данных для прогресс-бара по вопросам
        count_all = CollectInfo::Question.by_type(@project.type_for_questions).joins(:core_aspect).where('core_aspect_posts.project_id' => @project).count
        count_answered = CollectInfo::UserAnswers.select(' DISTINCT "collect_info_user_answers"."question_id" ').joins(:question).where(collect_info_questions: {project_id: @project, type_stage: @project.type_for_questions} ).where(collect_info_user_answers: {user_id: current_user}).count
        @questions_progress = count_all == 0 ? 0 : (count_answered.to_f/count_all.to_f) * 100
      end
    end
  end

  private

  def set_aspects
    # @todo выбираем только аспекты первого уровня (без вложенности)
    @aspects = @project.main_aspects
  end
end
