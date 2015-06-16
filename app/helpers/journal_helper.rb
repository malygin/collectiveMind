module JournalHelper
  def journal_icon(j)
    case j
      when /_approve_status/
        'fa-exclamation'
      when /_comment_dislike/
        'fa-thumbs-down'
      when /_comment_like/
        'fa-thumbs-up'
      when /reply_/
        'fa-reply'
      when /_post_save/
        'fa-plus'
      when /my_add_score_/
        'fa-trophy'
      when /_comment/
        'fa-comment'
    end
  end

  def journal_color(j)
    case j
    when  /core_aspect/
      'font_color_stage1'
    when /discontent/
      'font_color_stage2'
    when /novation/
      'font_color_stage3'
    when /concept/
      'font_color_stage4'
    when /plan/
      'font_color_stage5'
    end
  end

  def journal_parser(j, project)
    case j.type_event
      # COLLECT INFO
      when 'core_aspect_post_save'
        'добавил(а) аспект ' + link_to("#{j.body}..", "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}")
      when 'core_aspect_comment_save'
        "добавил(а) комментарий: '#{j.body} ...' к аспекту:  " + link_to("#{j.body2}", "/project/#{project}/collect_info/posts/?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_core_aspect_comment'
        "добавил(а) комментарий: '#{j.body}'" + link_to(' к вашему аспекту ', "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'reply_core_aspect_comment'
        "добавил(а) комментарий: '#{j.body}'" + link_to(" в ответ на ваш '#{j.body2}'", "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'core_aspect_post_approve_status'
        'выделил(а) аспект  ' + link_to("#{j.body}", "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}") + ' как важный'
      when 'my_core_aspect_post_approve_status'
        'выделил(а) ваш аспект  ' + link_to("#{j.body}", "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true") + ' как важный'
      when 'core_aspect_comment_approve_status'
        "выделил(а) комментарий: '#{j.body}'" + link_to(' к аспекту ', "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      when 'my_core_aspect_comment_approve_status'
        "выделил(а) ваш комментарий: '#{j.body}'" + link_to(' к аспекту ', "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'

      when 'my_core_aspect_post_like'
        'понравился ваш аспект ' + link_to("#{j.body}", "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_core_aspect_comment_like'
        "понравился ваш комментарий: '#{j.body}'" + link_to(' к аспекту ', "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_core_aspect_post_dislike'
        'не понравился ваш аспект ' + link_to("#{j.body}", "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_core_aspect_comment_dislike'
        "не понравился ваш комментарий: '#{j.body}'" + link_to(' к аспекту ', "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'my_add_score_core_aspect_post'
        "вы получили #{j.body} баллов за аспект " + link_to(j.body2, "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true")

      # DISCONTENTS
      when 'discontent_post_save'
        if j.anonym
          " #{t('journal.add_anonym_discontent')} #{link_to("#{j.body}", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}")}"
        else
          'добавил(а) несовершенство  ' + link_to("#{j.body}", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}")
        end
      when 'discontent_comment_save'
        "добавил(а) комментарий: '#{j.body}'" + ' к несовершенству ' + link_to("#{j.body2} ... ", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_discontent_comment'
        "добавил(а) комментарий '#{j.body}...' к вашему несовершенству " + link_to(j.body2, "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'reply_discontent_comment'
        "добавил(а) комментарий '#{j.body}...' в ответ на ваш " + link_to(j.body2, "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'discontent_post_approve_status'
        'выделил(а) несовершенство  ' + link_to("#{j.body}", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}") + ' как важное'
      when 'my_discontent_post_approve_status'
        'выделил(а) ваше несовершенство  ' + link_to("#{j.body}", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true") + ' как важное'
      when 'discontent_comment_approve_status'
        "выделил(а) комментарий '#{j.body}...' к несовершенству " + link_to(j.body2, "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      when 'my_discontent_comment_approve_status'
        "выделил(а) ваш комментарий '#{j.body}...' к несовершенству " + link_to(j.body2, "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'

      when 'my_discontent_post_like'
        'понравилось ваше несовершенство ' + link_to("#{j.body}", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_discontent_comment_like'
        "понравился ваш комментарий: '#{j.body}'" + link_to(' к несовершенству ', "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_discontent_post_dislike'
        'не понравилось ваше несовершенство ' + link_to("#{j.body}", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_discontent_comment_dislike'
        "не понравился ваш комментарий: '#{j.body}'" + link_to(' к несовершенству ', "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'my_add_score_discontent_post'
        "вы получили #{j.body} баллов за несовершенство " + link_to(j.body2, "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true")

      # CONCEPTS

      when 'concept_post_save'
        'добавил(а) идею  ' + link_to("#{j.body}", "/project/#{project}/concept/posts?jr_post=#{j.first_id}")
      when 'concept_comment_save'
        "добавил(а) комментарий: '#{j.body}'" + ' к идее ' + link_to("#{j.body2} ... ", "/project/#{project}/concept/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_concept_comment'
        "добавил(а) комментарий '#{j.body}...' к вашей идее " + link_to(j.body2, "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'reply_concept_comment'
        "добавил(а) комментарий '#{j.body}...' в ответ на ваш " + link_to(j.body2, "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'concept_post_approve_status'
        'выделил(а) идею  ' + link_to("#{j.body}", "/project/#{project}/concept/posts?jr_post=#{j.first_id}") + ' как важную'
      when 'my_concept_post_approve_status'
        'выделил(а) вашу идею  ' + link_to("#{j.body}", "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true") + ' как важную'
      when 'concept_comment_approve_status'
        "выделил(а) комментарий '#{j.body}...' к идее " + link_to(j.body2, "/project/#{project}/concept/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      when 'my_concept_comment_approve_status'
        "выделил(а) ваш комментарий '#{j.body}...' к идее " + link_to(j.body2, "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'

      when 'my_concept_post_like'
        'понравилась ваша идея ' + link_to("#{j.body}", "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_concept_comment_like'
        "понравился ваш комментарий: '#{j.body}'" + link_to(' к идее ', "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_concept_post_dislike'
        'не понравилась ваша идея ' + link_to("#{j.body}", "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_concept_comment_dislike'
        "не понравился ваш комментарий: '#{j.body}'" + link_to(' к идее ', "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'my_add_score_concept_post'
        "вы получили #{j.body} баллов за идею " + link_to(j.body2, "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true")

      # NOVATIONS

      when 'novation_post_save'
        'добавил(а) пакет  ' + link_to("#{j.body}", "/project/#{project}/novation/posts?jr_post=#{j.first_id}")
      when 'novation_comment_save'
        "добавил(а) комментарий: '#{j.body}'" + ' к пакету ' + link_to("#{j.body2} ... ", "/project/#{project}/novation/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_novation_comment'
        "добавил(а) комментарий '#{j.body}...' к вашему пакету " + link_to(j.body2, "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'reply_novation_comment'
        "добавил(а) комментарий '#{j.body}...' в ответ на ваш " + link_to(j.body2, "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'novation_post_approve_status'
        'выделил(а) пакет  ' + link_to("#{j.body}", "/project/#{project}/novation/posts?jr_post=#{j.first_id}") + ' как важный'
      when 'my_novation_post_approve_status'
        'выделил(а) ваш пакет  ' + link_to("#{j.body}", "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true") + ' как важный'
      when 'novation_comment_approve_status'
        "выделил(а) комментарий '#{j.body}...' к пакету " + link_to(j.body2, "/project/#{project}/novation/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      when 'my_novation_comment_approve_status'
        "выделил(а) ваш комментарий '#{j.body}...' к пакету " + link_to(j.body2, "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'

      when 'my_novation_post_like'
        'понравился ваш пакет ' + link_to("#{j.body}", "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_novation_comment_like'
        "понравился ваш комментарий: '#{j.body}'" + link_to(' к пакету ', "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_novation_post_dislike'
        'не понравился ваш пакет ' + link_to("#{j.body}", "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_novation_comment_dislike'
        "не понравился ваш комментарий: '#{j.body}'" + link_to(' к пакету ', "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'my_add_score_novation_post'
        "вы получили #{j.body} баллов за пакет " + link_to(j.body2, "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true")

      # PLANS

      when 'plan_post_save'
        'добавил(а) проект  ' + link_to("#{j.body}", "/project/#{project}/plan/posts?jr_post=#{j.first_id}")
      when 'plan_comment_save'
        "добавил(а) комментарий: '#{j.body}'" + ' к проекту ' + link_to("#{j.body2} ... ", "/project/#{project}/plan/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_plan_comment'
        "добавил(а) комментарий '#{j.body}...' к вашему проекту " + link_to(j.body2, "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'reply_plan_comment'
        "добавил(а) комментарий '#{j.body}...' в ответ на ваш " + link_to(j.body2, "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'plan_post_approve_status'
        'выделил(а) проект  ' + link_to("#{j.body}", "/project/#{project}/plan/posts?jr_post=#{j.first_id}") + ' как важный'
      when 'my_plan_post_approve_status'
        'выделил(а) ваш проект  ' + link_to("#{j.body}", "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true") + ' как важный'
      when 'plan_comment_approve_status'
        "выделил(а) комментарий '#{j.body}...' к проекту " + link_to(j.body2, "/project/#{project}/plan/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      when 'my_plan_comment_approve_status'
        "выделил(а) ваш комментарий '#{j.body}...' к проекту " + link_to(j.body2, "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'

      when 'my_plan_post_like'
        'понравился ваш проект ' + link_to("#{j.body}", "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_plan_comment_like'
        "понравился ваш комментарий: '#{j.body}'" + link_to(' к проекту ', "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_plan_post_dislike'
        'не понравился ваш проект ' + link_to("#{j.body}", "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_plan_comment_dislike'
        "не понравился ваш комментарий: '#{j.body}'" + link_to(' к проекту ', "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'my_add_score_plan_post'
        "вы получили #{j.body} баллов за проект " + link_to(j.body2, "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true")

      else
        'что то другое'
    end
  end

  def class_for_journal(current_user, journal)
    if current_user && current_user.last_seen_news && current_user.last_seen_news > journal.created_at
      ''
    else
      'unread_news'
    end
  end
end
