module UsersHelper
  def available_form_adding_frustration?(user)
    signed_in? and current_user == user and current_user.frustrations.count < Settings.max_frustration
  end

  def set_class_for_top(number)
    if number <= 3
      'top3'
    elsif 3 < number && number <= 10
      'top10'
    else
      nil
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

end
