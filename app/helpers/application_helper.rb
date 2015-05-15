module ApplicationHelper

  def user_image_tag(source, options = {})
    if source
      cl_image_tag source, options
    else
      image_tag 'no-ava.png', options
    end
  end

  def escape_text(t)
    t.gsub("\n", "\\n").gsub("\r", "\\r").gsub("\t", "\\t").gsub("'", "\\'")
  end

  def trim_content(s, l=100)
    if s
      s[0..l]
    end
  end




  # @todo for stage helper
  def current_stage?(stage)
    if stage == 1 and @project.status == 2
      true
    elsif stage == 2 and @project.status == 6
      true
    elsif stage == 3 and @project.status == 8
      true
    elsif stage == 4 and @project.status == 9
      true
    elsif stage == 5 and @project.status == 11
      true
    else
      false
    end
  end

  # @todo for refac
  def get_stage_for_improve(c)
    case c
      when 'Core::Aspect'
        1
      when 'Discontent'
        2
      when 'Concept'
        3
      when 'Novation'
        4
      when 'Plan'
        5
      when 'Estimate'
        6
      when 'Essay'
        7
    end
  end
  # @todo for refac
  def improve_comment(post)
    if post.improve_comment and post.improve_stage
      comment =get_comment_for_stage(post.improve_stage.to_s, post.improve_comment)
      case post.improve_stage
        when 1
          "| #{t('show.improved')} " + (link_to "#{t('show.imrove_deal')} #{comment.user}", "/project/#{@project.id}/collect_info/posts?asp=#{comment.post.core_aspects.first.id}&req_comment=#{comment.id}#comment_#{comment.id}")
        when 2
          "| #{t('show.improved')} " + (link_to t('show.imrove_deal'), "/project/#{@project.id}/discontent/posts/#{comment.post.id}#comment_#{comment.id}") + (link_to comment.user, user_path(@project, comment.user))
        when 3
          "| #{t('show.improved')} " + (link_to t('show.imrove_deal'), "/project/#{@project.id}/concept/posts/#{comment.post.id}#comment_#{comment.id}") + (link_to comment.user, user_path(@project, comment.user))
      end
    end
  end
  # @todo for refac
  def link_for_improve(comment)
    comment_class = get_stage_for_improve(comment.get_class)
    case comment_class
      when 1
        link_to "/project/#{@project.id}/collect_info/posts?asp=#{comment.post.core_aspects.first.id}#comment_#{comment.id}" do
          content_tag :span, t('show.improver'), class: 'btn btn-primary btn-xs'
        end
      when 2
        link_to "/project/#{@project.id}/discontent/posts/#{comment.post.id}#comment_#{comment.id}" do
          content_tag :span, t('show.improver'), class: 'btn btn-primary btn-xs'
        end
      when 3
        link_to "/project/#{@project.id}/concept/posts/#{comment.post.id}#comment_#{comment.id}" do
          content_tag :span, t('show.improver'), class: 'btn btn-primary btn-xs'
        end
    end
  end
  # @todo for refac
  def comment_stat_color(comment)
    if comment.discuss_status
      'discuss_comment'
    elsif comment.user.role_stat == 2
      'expert_comment'
    end
  end

  # @todo for stage helper
  def status_project(project)
    if [0, 1, 2].include? project.status
      t('show.go_proc', count: 1)
    elsif [3, 4, 5, 6].include? project.status
      t('show.go_proc', count: 2)
    elsif [7, 8].include? project.status
      t('show.go_proc', count: 3)
    elsif [9].include? project.status
      t('show.go_proc', count: 4)
    elsif [10, 11, 12].include? project.status
      t('show.go_proc', count: 5)
    elsif [20].include? project.status
      t('show.completed_proc')
    end
  end

  # @todo for journal helper
  def field_for_journal(post)
    if post.instance_of? Concept::Post or post.instance_of? Novation::Post
      post.title
    elsif post.instance_of? Plan::Post
      post.name
    else
      post.content
    end
  end



  def show_flash(flash)
    response = ""
    flash.each do |name, msg|
      response = response + content_tag(:div, msg, id: "flash_#{name}", class: "color-red", style: "font-size:15px;")
    end
    flash.discard
    response
  end

  def role_label(user)
    if user.boss?
      content_tag :span, 'MD', class: 'label label-danger'
      # elsif user.role_expert?
      #   content_tag :span, t('show.expert'), class: 'label label-success'
    end
  end


  def name_controller
    controller.class.to_s.gsub('::', '_').gsub('Controller', '').underscore.to_sym
  end

  ##
  # Хелперовский метод, вернет `true` если мы в кабинете
  # т.е. если мы на странице project_user или создаем контент
  # или просматриваем свой созданный контент
  def cabinet?
    name_controller == :core_project_users or action_name == 'new' or action_name == 'user_content' or action_name == 'edit'
  end

  def profile?
    controller_name == 'users' and action_name == 'show'
  end

  def rating?
    controller_name == 'users' and action_name == 'index'
  end

  def current_stage_controller
    # Если это контроллер для кабинета, возвращаем номер текущей стадии
    if cabinet?
      return @project.current_stage.first[0]
    end
    Core::Project::LIST_STAGES.each do |num_stage, stage|
      return num_stage if name_controller == stage[:type_stage]
    end
    0
  end

  def color_progress_bar
    case name_controller
      when :collect_info_posts
        "#649ac3"
      when :discontent_posts
        "#486795"
      when :concept_posts
        "#bd8cb8"
      when :novation_posts
        "#7373aa"
      when :plan_posts
        "#80bcc4"
      when :estimate_posts
        "#80bcc4"
      else
        "#649ac3"
    end
  end



  def label_for_comment_status(comment, status, title)
    if comment.check_status_for_label(status)
      if (current_user?(comment.user) or boss? or role_expert? or stat_expert?) and (status == 'concept' or (status == 'discontent' and @project.status < 4))
        link_to({controller: comment.controller_name_for_action, action: :comment_status, id: comment.post.id, comment_id: comment.id, status => 1, comment_stage: get_stage_for_improve(comment.get_class)}, remote: true, method: :put, id: "#{status}_comment_#{comment.id}") do
          content_tag(:span, title, class: "label #{css_label_status(status)}")
        end
      else
        content_tag(:span, title, class: "label #{css_label_status(status)}")
      end
    else
      if (current_user?(comment.user) or boss? or role_expert? or stat_expert?) and (status == 'concept' or (status == 'discontent' and @project.status < 4))
        link_to({controller: comment.controller_name_for_action, action: :comment_status, id: comment.post.id, comment_id: comment.id, status => 1, comment_stage: get_stage_for_improve(comment.get_class)}, remote: true, method: :put, id: "#{status}_comment_#{comment.id}") do
          content_tag(:span, title, class: "label label-default")
        end
      end
    end
  end

  def grouped_discontent?(post)
    if @concept_post.present?
      if @concept_post.persisted?
        post.concept_post_discontent_checks.by_concept(@concept_post).present?
      else
        true
      end
    elsif @post.present? and @post.persisted?
      post.concept_post_discontent_checks.by_concept(@post).present?
    else
      true
    end
  end





  def score_order(score_name)
    case score_name
      when 'score_g'
        "core_project_scores.score_g DESC"
      when 'score_a'
        "core_project_scores.score_a DESC"
      when 'score_o'
        "core_project_scores.score_o DESC"
      else
        "core_project_scores.score DESC"
    end
  end

  # @todo only for mailer?
  def date_stage_for_project(project)
    date_now = 1.day.ago.utc
    if project.date_12 >= date_now
      'Сбор несовершенств'
    elsif project.date_23 >= date_now
      'Сбор нововведений'
    elsif project.date_34 >= date_now
      'Создание проектов'
    elsif project.date_45 >= date_now
      'Выставление оценок'
    end
  end


  # необходимость показа приветсвенной модалки или поповера
  #@todo почему бы не возвращать boolean? он там
  def shown_intro(check_field)
    current_user.user_checks.check_field(@project, check_field).present?
  end

  # Показывать ли стикер в кабинете?
  def show_sticker?(check_field)
    current_user.user_checks.check_field(@project, check_field).present?
  end

  # последняя дата захода на страницу
  def last_time_visit_page(stage, type_event = 'visit_save', post = nil)
    if post
      notice = current_user.loggers.where(type_event: type_event, project_id: @project.id, user_id: current_user.id).where("body = ?", "/project/#{@project.id}/#{stage}/posts/#{post.id}").order(created_at: :desc).first
    else
      notice = current_user.loggers.where(type_event: type_event, project_id: @project.id, user_id: current_user.id).where("body = ?", "/project/#{@project.id}/#{stage}/posts").order(created_at: :desc).first
    end
    notice ? notice.created_at : "2000-01-01 00:00:00"
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

  def current_stage_popover_status
    if name_controller == :collect_info_posts and @project.status == 0 and @questions_progress != 100
      'collect_info_questions_0'
    elsif name_controller == :collect_info_posts and @project.status == 0 and @questions_progress == 100
      'collect_info_discuss_0'
    elsif name_controller == :collect_info_posts and @project.status == 1 and @questions_progress != 100
      'collect_info_questions_1'
    elsif name_controller == :collect_info_posts and @project.status == 1 and @questions_progress == 100
      'collect_info_discuss_1'
    elsif name_controller == :collect_info_posts and @project.status > 1 and @questions_progress != 100
      'collect_info_questions_1'
    elsif name_controller == :collect_info_posts and @project.status > 1 and @questions_progress == 100
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
    if name_controller == :collect_info_posts and @project.status == 0 and @questions_progress != 100
      'Прочитайте базу знаний, переходя от аспекта к аспекту и отвечая ДА или НЕТ на наши простые вопросы.<br>' +
          'Вы можете комментировать свои ответы в поле “Пояснение”. Ответив на все вопросы, вы перейдете на этап обсуждения и добавления аспектов.<br>' +
          'Обратите внимание: раздел ”Введение в процедуру” — это не аспект, а просто введение в процедуру!'
    elsif name_controller == :collect_info_posts and @project.status == 1 and @questions_progress != 100
      'Еще раз прочитайте базу знаний и ответьте на несколько несложных вопросов на ее понимание.'
    elsif name_controller == :collect_info_posts and @questions_progress == 100
      'Здесь можно обсуждать аспекты, подготовленные оргкомитетом (слева) и предложенные другими участниками процедуры (справа).<br>' +
          'Нажав на кнопку “Добавить аспект”, вы попадете на экран, где сможете сформулировать и опубликовать собственный аспект<br>' +
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
    sub_url = project.current_stage_type.to_s.gsub('_', '/')
    if [:collect_info_posts, :completion_proc_posts].include? project.current_stage_type
      sub_url.sub!('/', '_')
    end
    "/project/#{project.id}/#{sub_url}"
  end

  # @todo bad markup in body not css for different stage
  def stage_theme
    if rating?
      'grey_theme'
    elsif profile?
      'white_theme'
    else
      "stage#{current_stage_controller}_theme"
    end
  end

end
