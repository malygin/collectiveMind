module ApplicationHelper
  def name_controller
    controller.class.to_s.gsub('::', '_').gsub('Controller', '').underscore.to_sym
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

  def able_subbar?
    name_controller == @project.current_stage_type && Core::Project::STAGES[@project.main_stage][:substages]
  end

  def number_current_stage
    Core::Project::STAGES.each do |num_stage, stage|
      return num_stage if name_controller == stage[:type_stage] || name_controller == :core_aspect_posts
    end
    nil
  end

  def can_edit_content?
    name_controller == @project.current_stage_type
  end

  # необходимость показа приветсвенной модалки или поповера
  # @todo почему бы не возвращать boolean?
  def shown_intro(check_field)
    current_user.user_checks.check_field(@project, check_field).present? ? 'shown_intro' : ''
  end

  # Показывать ли стикер в кабинете?
  def show_sticker?(check_field)
    current_user.user_checks.check_field(@project, check_field).present?
  end

  # последняя дата захода на страницу
  def last_time_visit_page(stage, type_event = 'visit_save', post = nil)
    if post
      notice = current_user.loggers.where(type_event: type_event, project_id: @project.id, user_id: current_user.id).where('body = ?', "/project/#{@project.id}/#{stage}/posts/#{post.id}").order(created_at: :desc).first
    else
      notice = current_user.loggers.where(type_event: type_event, project_id: @project.id, user_id: current_user.id).where('body = ?', "/project/#{@project.id}/#{stage}/posts").order(created_at: :desc).first
    end
    notice ? notice.created_at : '2000-01-01 00:00:00'
  end

  # # дата прочтения новости эксперта
  # def expert_news_read?(news)
  #   current_user.loggers.where(type_event: 'expert_news_read', project_id: @project.id, user_id: current_user.id, first_id: news.id).order(created_at: :desc).first
  # end

  # возвращаем true, если есть непрочитанные новости эксперта
  def unread_expert_news?
    count_news_log = current_user.loggers.select(' DISTINCT "journal_loggers"."first_id" ').where(type_event: 'expert_news_read', project_id: @project.id, user_id: current_user.id).count
    @project.news.count - count_news_log > 0
  end

  # @todo refac
  def current_stage_popover_status
    if name_controller == :collect_info_posts && @project.stage == '1:0' && @questions_progress != 100
      'collect_info_questions_0'
    elsif name_controller == :collect_info_posts && @project.stage == '1:0' && @questions_progress == 100
      'collect_info_discuss_0'
    elsif name_controller == :collect_info_posts && @project.stage == '1:1' && @questions_progress != 100
      'collect_info_questions_1'
    elsif name_controller == :collect_info_posts && @project.stage == '1:1' && @questions_progress == 100
      'collect_info_discuss_1'
    elsif name_controller == :collect_info_posts && (@project.main_stage > 1 || @project.stage == '1:2') && @questions_progress != 100
      'collect_info_questions_1'
    elsif name_controller == :collect_info_posts && (@project.main_stage > 1 || @project.stage == '1:2') && @questions_progress == 100
      'collect_info_discuss_1'
    elsif name_controller == :discontent_posts
      'discontent_discuss'
    elsif name_controller == :concept_posts
      'concept_discuss'
    elsif name_controller == :novation_posts
      'novation_discuss'
    elsif name_controller == :plan_posts
      'plan_discuss'
    elsif name_controller == :estimate_posts
      'estimate_discuss'
    elsif name_controller == :completion_proc_posts
      'completion_proc_discuss'
    end
  end

  # @todo refac
  def current_stage_popover_text
    if name_controller == :collect_info_posts && @project.stage == '1:0' && @questions_progress != 100
      'Прочитайте базу знаний, переходя от аспекта к аспекту и отвечая ДА или НЕТ на наши простые вопросы.<br>' \
          'Вы можете комментировать свои ответы в поле “Пояснение”. Ответив на все вопросы, вы перейдете на этап обсуждения и добавления аспектов.<br>' \
          'Обратите внимание: раздел ”Введение в процедуру” — это не аспект, а просто введение в процедуру!'
    elsif name_controller == :collect_info_posts && @project.stage == '1:1' && @questions_progress != 100
      'Прочитайте подготовленное методологом описание ситуации на вкладке «Введение в процедуру». После этого ответьте на вопросы на трех остальных вкладках.<span class="font_red bold"> ВАШИ ОТВЕТЫ ПОСЛУЖАТ ОСНОВОЙ ДЛЯ БАЗЫ ЗНАНИЙ.</span>'\
       'Ответив на вопросы или выбрав возможность «Пропустить вопрос», вы сможете перейти к обсуждению прочитанного с остальными участниками.'
    elsif name_controller == :collect_info_posts && @questions_progress == 100
      'Здесь можно обсуждать аспекты, подготовленные оргкомитетом (слева) и предложенные другими участниками процедуры (справа).<br>' \
          'Нажав на кнопку “Добавить аспект”, вы попадете на экран, где сможете сформулировать и опубликовать собственный аспект<br>' \
          'Прежде чем отправиться туда, внимательно прочитайте все предложенные аспекты и убедитесь, что ваше предложение не дублирует ни один из них.'
    elsif name_controller == :discontent_posts
      'Высказывайте все, что вас не устраивает в текущей ситуации! Не забывайте, что для каждой выявленной проблемы впоследствии будет подбираться решение, поэтому следите, чтобы ваши несовершенства были конкретными.'
    elsif name_controller == :concept_posts
      'Идеи, предложенные на этой стадии, в дальнейшем будут объединяться в пакеты.'
    else
      'Здесь могла быть подсказка, но пока ее нет!'
    end
  end

  def current_stage_url(project)
    "/project/#{project.id}/"
  end

  def model_for(type, stage)
    # stage symbol and downcase -> to string and capitalize
    if type == :post
      stage == :collect_info_posts ? Core::Aspect::Post : "#{stage.to_s.gsub('_posts', '').capitalize}::Post".constantize
    elsif type == :comment
      stage == :collect_info_posts ? Core::Aspect::Comment : "#{stage.to_s.gsub('_posts', '').capitalize}::Comment".constantize
    end
  end

  def collect_info_answers_count(project)
    # подсчет данных для прогресс-бара по вопросам
    # число вопросов по процедуре
    count_all = CollectInfo::Question.by_type(project.type_for_questions).joins(:core_aspect).where('core_aspect_posts.project_id' => project).count
    # число вопросов на которые пользователь ответил
    count_answered = CollectInfo::UserAnswers.select(' DISTINCT "collect_info_user_answers"."question_id" ').joins(:question).where(collect_info_questions: { project_id: project, type_stage: project.type_for_questions }).where(collect_info_user_answers: { user_id: current_user }).count
    # прогресс для данного пользователя
    questions_progress = count_all == 0 ? 0 : (count_answered.to_f / count_all.to_f) * 100

    # общее количество ответов пользователей закрытой процедуры
    if project.closed?
      users_count = project.users.count
      count_answered_all = CollectInfo::UserAnswers.select('"collect_info_user_answers"."question_id"').joins(:question).where(collect_info_questions: { project_id: project, type_stage: project.type_for_questions }).count
      questions_progress_all = count_all * users_count == 0 ? 0 : (count_answered_all.to_f / (count_all * users_count).to_f) * 100
    end
    [questions_progress, questions_progress_all]
  end
end
