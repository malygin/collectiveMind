module ApplicationHelper
  def name_controller
    controller.class.to_s.gsub('::', '_').gsub('Controller', '').underscore.to_sym
  end

  def name_model
    name_controller.to_s.chomp('_posts').pluralize
  end

  def model_controller
    name_controller.to_s.chomp('_posts')
  end

  ##
  # Хелперовский метод, вернет `true` если мы в кабинете
  # т.е. если мы на странице project_user или создаем контент
  # или просматриваем свой созданный контент
  def cabinet?
    name_controller == :core_project_users || action_name == 'new' || action_name == 'user_content' || action_name == 'edit'
  end

  def profile?
    controller_name == 'users' && action_name == 'show'
  end

  def rating?
    controller_name == 'users' && action_name == 'index'
  end

  def left_rollover?
    name_controller == :concept_posts
  end

  def show_stage_subbar?
    name_controller == @project.current_stage_type && Core::Project::STAGES[@project.main_stage][:substages]
  end

  def substage_status_by(num)
    if @project.sub_stage == num
      'current'
    elsif @project.sub_stage < num
      'unavailable'
    else
      'complete'
    end
  end

  def number_current_stage
    Core::Project::STAGES.each do |num_stage, stage|
      return num_stage if name_controller == stage[:type_stage]
    end
    nil
  end

  def can_edit_content?
    name_controller == @project.current_stage_type
  end

  # Показывалось ли уже?
  def show_check_field?(check_field)
    current_user.user_checks.check_field(@project, check_field).present?
  end

  # последняя дата захода на страницу
  def last_time_visit_page(stage = model_controller, type_event = 'visit_save', post = nil)
    post_id = post ? "/#{post.id}" : ''
    notice = current_user.loggers.where(type_event: type_event, project_id: @project.id, request_format: 'html')
             .where('body = ?', "/project/#{@project.id}/#{stage}/posts" + post_id).first
    notice ? notice.created_at : '2000-01-01 00:00:00'
  end

  # # дата прочтения новости эксперта
  # def expert_news_read?(news)
  #   current_user.loggers.where(type_event: 'expert_news_read', project_id: @project.id, user_id: current_user.id, first_id: news.id).order(created_at: :desc).first
  # end

  # возвращаем true, если есть непрочитанные новости эксперта
  def unread_expert_news?
    count_news_log = current_user.loggers.select(' DISTINCT "journal_loggers"."first_id" ')
                     .where(type_event: 'expert_news_read', project_id: @project.id).count
    @project.news.count - count_news_log > 0
  end

  # for collect_info it collect_info_posts_sub_1_quesction_true and etc, for others just like discontent_posts
  def current_stage_popover_status
    if name_controller == :aspect_posts && @questions_progress != 100
      name_controller.to_s + "_stage_popover_sub_#{@project.sub_stage}"
    else
      name_controller.to_s + '_stage_popover'
    end
  end

  def current_stage_url(project)
    "/project/#{project.id}"
  end

  def model_for(type, stage)
    # stage symbol and downcase -> to string and capitalize
    if type == :post
      "#{stage.to_s.gsub('_posts', '').capitalize}::Post".constantize
    elsif type == :comment
      "#{stage.to_s.gsub('_posts', '').capitalize}::Comment".constantize
    end
  end

  def aspect_answers_count(project)
    # подсчет данных для прогресс-бара по вопросам
    # число вопросов по процедуре
    count_all = Aspect::Question.by_type(project.type_for_questions).joins(:aspect).where('aspect_posts.project_id' => project).count
    # число вопросов на которые пользователь ответил
    count_answered = Aspect::UserAnswer.answered_questions(project, current_user).count
    # прогресс для данного пользователя
    questions_progress = count_all == 0 ? 0 : (count_answered.to_f / count_all.to_f) * 100

    # общее количество ответов пользователей закрытой процедуры
    if project.closed?
      users_count = project.users.count
      count_answered_all = Aspect::UserAnswer.select('"aspect_user_answers"."question_id"').joins(:question)
                           .where(aspect_questions: { project_id: project, type_stage: project.type_for_questions }).count
      questions_progress_all = count_all * users_count == 0 ? 0 : (count_answered_all.to_f / (count_all * users_count).to_f) * 100
    end
    [questions_progress, questions_progress_all]
  end
end
