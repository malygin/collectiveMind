module JournalHelper
  def journal_icon(j)
    case j.type_event
      # статус Важно
      when 'core_aspect_post_approve_status', 'my_core_aspect_post_approve_status', 'core_aspect_comment_approve_status', 'my_core_aspect_comment_approve_status'
        'fa-exclamation font_color_stage1'
      when 'discontent_post_approve_status', 'my_discontent_post_approve_status', 'discontent_comment_approve_status', 'my_discontent_comment_approve_status'
        'fa-exclamation font_color_stage2'
      when 'concept_post_approve_status', 'my_concept_post_approve_status', 'concept_comment_approve_status', 'my_concept_comment_approve_status'
        'fa-exclamation font_color_stage3'
      when 'novation_post_approve_status', 'my_novation_post_approve_status', 'novation_comment_approve_status', 'my_novation_comment_approve_status'
        'fa-exclamation font_color_stage4'
      when 'plan_post_approve_status', 'my_plan_post_approve_status', 'plan_comment_approve_status', 'my_plan_comment_approve_status'
        'fa-exclamation font_color_stage5'
      # лайки
      when 'my_core_aspect_post_like', 'my_core_aspect_comment_like'
        'fa-thumbs-up font_color_stage1'
      when 'my_discontent_post_like', 'my_discontent_comment_like'
        'fa-thumbs-up font_color_stage2'
      when 'my_concept_post_like', 'my_concept_comment_like'
        'fa-thumbs-up font_color_stage3'
      when 'my_novation_post_like', 'my_novation_comment_like'
        'fa-thumbs-up font_color_stage4'
      when 'my_plan_post_like', 'my_plan_comment_like'
        'fa-thumbs-up font_color_stage5'
      #  дислайки
      when 'my_core_aspect_post_dislike', 'my_core_aspect_comment_dislike'
        'fa-thumbs-down font_color_stage1'
      when 'my_discontent_post_dislike', 'my_discontent_comment_dislike'
        'fa-thumbs-down font_color_stage2'
      when 'my_concept_post_dislike', 'my_concept_comment_dislike'
        'fa-thumbs-down font_color_stage3'
      when 'my_novation_post_dislike', 'my_novation_comment_dislike'
        'fa-thumbs-down font_color_stage4'
      when 'my_plan_post_dislike', 'my_plan_comment_dislike'
        'fa-thumbs-down font_color_stage5'
      # комменты
      when 'core_aspect_comment_save', 'my_core_aspect_comment'
        'fa-comment font_color_stage1'
      when 'discontent_comment_save', 'my_discontent_comment'
        'fa-comment font_color_stage2'
      when 'concept_comment_save', 'my_concept_comment'
        'fa-comment font_color_stage3'
      when 'novation_comment_save', 'my_novation_comment'
        'fa-comment font_color_stage4'
      when 'plan_comment_save', 'my_plan_comment'
        'fa-comment font_color_stage5'
      # ответы на комменты
      when 'reply_core_aspect_comment'
        'fa-reply font_color_stage1'
      when 'reply_discontent_comment'
        'fa-reply font_color_stage2'
      when 'reply_concept_comment'
        'fa-reply font_color_stage3'
      when 'reply_novation_comment'
        'fa-reply font_color_stage4'
      when 'reply_plan_comment'
        'fa-reply font_color_stage5'
      # добавление постов
      when 'core_aspect_post_save'
        'fa-plus font_color_stage1'
      when 'discontent_post_save'
        'fa-plus font_color_stage2'
      when 'concept_post_save'
        'fa-plus font_color_stage3'
      when 'novation_post_save'
        'fa-plus font_color_stage4'
      when 'plan_post_save'
        'fa-plus font_color_stage5'
      # баллы за контент
      when 'my_add_score_core_aspect_post'
        'fa-trophy font_color_stage1'
      when 'my_add_score_discontent_post'
        'fa-trophy font_color_stage2'
      when 'my_add_score_concept_post'
        'fa-trophy font_color_stage3'
      when 'my_add_score_novation_post'
        'fa-trophy font_color_stage4'
      when 'my_add_score_plan_post'
        'fa-trophy font_color_stage5'
    end
  end

  def journal_parser(j, project)
    case j.type_event
      #COLLECT INFO
      when 'core_aspect_post_save'
        'добавил(а) аспект '+ link_to("#{j.body}..", "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}")
      when 'core_aspect_comment_save'
        "добавил(а) комментарий: '#{j.body} ...' к аспекту:  "+ link_to("#{j.body2}", "/project/#{project}/collect_info/posts/?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_core_aspect_comment'
        "добавил(а) комментарий: '#{j.body}'"+ link_to(' к вашему аспекту ', "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'reply_core_aspect_comment'
        "добавил(а) комментарий: '#{j.body}'"+ link_to(" в ответ на ваш '#{j.body2}'", "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'core_aspect_post_approve_status'
        'выделил(а) аспект  ' + link_to("#{j.body}", "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}") + ' как важный'
      when 'my_core_aspect_post_approve_status'
        'выделил(а) ваш аспект  ' + link_to("#{j.body}", "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true") + ' как важный'
      when 'core_aspect_comment_approve_status'
        "выделил(а) комментарий: '#{j.body}'"+ link_to(' к аспекту ', "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      when 'my_core_aspect_comment_approve_status'
        "выделил(а) ваш комментарий: '#{j.body}'"+ link_to(' к аспекту ', "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'

      when 'my_core_aspect_post_like'
        'понравился ваш аспект ' + link_to("#{j.body}", "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_core_aspect_comment_like'
        "понравился ваш комментарий: '#{j.body}'" + link_to(' к аспекту ', "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_core_aspect_post_dislike'
        'не понравился ваш аспект ' + link_to("#{j.body}", "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_core_aspect_comment_dislike'
        "не понравился ваш комментарий: '#{j.body}'" + link_to(' к аспекту ', "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'my_add_score_core_aspect_post'
        "вы получили #{j.body} баллов за аспект "+ link_to(j.body2, "/project/#{project}/collect_info/posts?jr_post=#{j.first_id}&viewed=true")

      # DISCONTENTS
      when 'discontent_post_save'
        if j.anonym
          " #{t('journal.add_anonym_discontent')} #{link_to("#{j.body}", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}")}"
        else
          'добавил(а) несовершенство  ' + link_to("#{j.body}", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}")
        end
      when 'discontent_comment_save'
        "добавил(а) комментарий: '#{j.body}'"+ ' к несовершенству '+ link_to("#{j.body2} ... ", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_discontent_comment'
        "добавил(а) комментарий '#{j.body}...' к вашему несовершенству "+ link_to(j.body2, "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'reply_discontent_comment'
        "добавил(а) комментарий '#{j.body}...' в ответ на ваш "+ link_to(j.body2, "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'discontent_post_approve_status'
        'выделил(а) несовершенство  ' + link_to("#{j.body}", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}") + ' как важное'
      when 'my_discontent_post_approve_status'
        'выделил(а) ваше несовершенство  ' + link_to("#{j.body}", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true") + ' как важное'
      when 'discontent_comment_approve_status'
        "выделил(а) комментарий '#{j.body}...' к несовершенству "+ link_to(j.body2, "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      when 'my_discontent_comment_approve_status'
        "выделил(а) ваш комментарий '#{j.body}...' к несовершенству "+ link_to(j.body2, "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'


      when 'my_discontent_post_like'
        'понравилось ваше несовершенство ' + link_to("#{j.body}", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_discontent_comment_like'
        "понравился ваш комментарий: '#{j.body}'" + link_to(' к несовершенству ', "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_discontent_post_dislike'
        'не понравилось ваше несовершенство ' + link_to("#{j.body}", "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_discontent_comment_dislike'
        "не понравился ваш комментарий: '#{j.body}'" + link_to(' к несовершенству ', "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'my_add_score_discontent_post'
        "вы получили #{j.body} баллов за несовершенство "+ link_to(j.body2, "/project/#{project}/discontent/posts?jr_post=#{j.first_id}&viewed=true")

      # CONCEPTS

      when 'concept_post_save'
        'добавил(а) идею  ' + link_to("#{j.body}", "/project/#{project}/concept/posts?jr_post=#{j.first_id}")
      when 'concept_comment_save'
        "добавил(а) комментарий: '#{j.body}'"+ ' к идее '+ link_to("#{j.body2} ... ", "/project/#{project}/concept/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_concept_comment'
        "добавил(а) комментарий '#{j.body}...' к вашей идее "+ link_to(j.body2, "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'reply_concept_comment'
        "добавил(а) комментарий '#{j.body}...' в ответ на ваш "+ link_to(j.body2, "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'concept_post_approve_status'
        'выделил(а) идею  ' + link_to("#{j.body}", "/project/#{project}/concept/posts?jr_post=#{j.first_id}") + ' как важную'
      when 'my_concept_post_approve_status'
        'выделил(а) вашу идею  ' + link_to("#{j.body}", "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true") + ' как важную'
      when 'concept_comment_approve_status'
        "выделил(а) комментарий '#{j.body}...' к идее "+ link_to(j.body2, "/project/#{project}/concept/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      when 'my_concept_comment_approve_status'
        "выделил(а) ваш комментарий '#{j.body}...' к идее "+ link_to(j.body2, "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'


      when 'my_concept_post_like'
        'понравилась ваша идея ' + link_to("#{j.body}", "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_concept_comment_like'
        "понравился ваш комментарий: '#{j.body}'" + link_to(' к идее ', "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_concept_post_dislike'
        'не понравилась ваша идея ' + link_to("#{j.body}", "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_concept_comment_dislike'
        "не понравился ваш комментарий: '#{j.body}'" + link_to(' к идее ', "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'my_add_score_concept_post'
        "вы получили #{j.body} баллов за идею "+ link_to(j.body2, "/project/#{project}/concept/posts?jr_post=#{j.first_id}&viewed=true")

      # NOVATIONS

      when 'novation_post_save'
        'добавил(а) пакет  ' + link_to("#{j.body}", "/project/#{project}/novation/posts?jr_post=#{j.first_id}")
      when 'novation_comment_save'
        "добавил(а) комментарий: '#{j.body}'"+ ' к пакету '+ link_to("#{j.body2} ... ", "/project/#{project}/novation/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_novation_comment'
        "добавил(а) комментарий '#{j.body}...' к вашему пакету "+ link_to(j.body2, "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'reply_novation_comment'
        "добавил(а) комментарий '#{j.body}...' в ответ на ваш "+ link_to(j.body2, "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'novation_post_approve_status'
        'выделил(а) пакет  ' + link_to("#{j.body}", "/project/#{project}/novation/posts?jr_post=#{j.first_id}") + ' как важный'
      when 'my_novation_post_approve_status'
        'выделил(а) ваш пакет  ' + link_to("#{j.body}", "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true") + ' как важный'
      when 'novation_comment_approve_status'
        "выделил(а) комментарий '#{j.body}...' к пакету "+ link_to(j.body2, "/project/#{project}/novation/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      when 'my_novation_comment_approve_status'
        "выделил(а) ваш комментарий '#{j.body}...' к пакету "+ link_to(j.body2, "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'


      when 'my_novation_post_like'
        'понравился ваш пакет ' + link_to("#{j.body}", "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_novation_comment_like'
        "понравился ваш комментарий: '#{j.body}'" + link_to(' к пакету ', "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_novation_post_dislike'
        'не понравился ваш пакет ' + link_to("#{j.body}", "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_novation_comment_dislike'
        "не понравился ваш комментарий: '#{j.body}'" + link_to(' к пакету ', "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'my_add_score_novation_post'
        "вы получили #{j.body} баллов за пакет "+ link_to(j.body2, "/project/#{project}/novation/posts?jr_post=#{j.first_id}&viewed=true")


      # PLANS

      when 'plan_post_save'
        'добавил(а) проект  ' + link_to("#{j.body}", "/project/#{project}/plan/posts?jr_post=#{j.first_id}")
      when 'plan_comment_save'
        "добавил(а) комментарий: '#{j.body}'"+ ' к проекту '+ link_to("#{j.body2} ... ", "/project/#{project}/plan/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_plan_comment'
        "добавил(а) комментарий '#{j.body}...' к вашему проекту "+ link_to(j.body2, "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'reply_plan_comment'
        "добавил(а) комментарий '#{j.body}...' в ответ на ваш "+ link_to(j.body2, "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'plan_post_approve_status'
        'выделил(а) проект  ' + link_to("#{j.body}", "/project/#{project}/plan/posts?jr_post=#{j.first_id}") + ' как важный'
      when 'my_plan_post_approve_status'
        'выделил(а) ваш проект  ' + link_to("#{j.body}", "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true") + ' как важный'
      when 'plan_comment_approve_status'
        "выделил(а) комментарий '#{j.body}...' к проекту "+ link_to(j.body2, "/project/#{project}/plan/posts?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      when 'my_plan_comment_approve_status'
        "выделил(а) ваш комментарий '#{j.body}...' к проекту "+ link_to(j.body2, "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'


      when 'my_plan_post_like'
        'понравился ваш проект ' + link_to("#{j.body}", "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_plan_comment_like'
        "понравился ваш комментарий: '#{j.body}'" + link_to(' к проекту ', "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'my_plan_post_dislike'
        'не понравился ваш проект ' + link_to("#{j.body}", "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true")
      when 'my_plan_comment_dislike'
        "не понравился ваш комментарий: '#{j.body}'" + link_to(' к проекту ', "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true&jr_comment=#{j.second_id}#comment_#{j.second_id}")

      when 'my_add_score_plan_post'
        "вы получили #{j.body} баллов за проект "+ link_to(j.body2, "/project/#{project}/plan/posts?jr_post=#{j.first_id}&viewed=true")

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
