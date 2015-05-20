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


      # when 'plan_post_save'
      #   'fa fa-plus color-green'
      # when 'plan_post_update'
      #   'fa fa-edit color-green'
      # when 'plan_comment_save'
      #   'fa fa-comment color-green'
      #
      # when 'concept_post_save'
      #   'fa fa-plus color-orange'
      # when 'concept_post_update'
      #   'fa fa-edit color-orange'
      # when 'concept_comment_save'
      #   'fa fa-comment color-orange'
      #
      # when 'discontent_post_save'
      #   'fa fa-plus color-red'
      # when 'discontent_post_update'
      #   'fa fa-edit color-red'
      # when 'discontent_comment_save', 'my_discontent_comment'
      #   'fa fa-comment color-red'
      # when 'life_tape_post_save'
      #   'fa fa-plus color-teal'
      # when 'life_tape_comment_save'
      #   'fa fa-comment color-teal'
      # when 'award_1like', 'award_3likes', 'award_5likes', 'award_15likes', 'award_50likes',
      #     'award_1imperfection', 'award_3imperfection', 'award_5imperfection', 'award_15imperfection',
      #     'award_1innovation', 'award_3innovation', 'award_5innovation', 'award_15innovation',
      #     'award_100points', 'award_500points', 'award_1000points', 'award_3000points', 'my_add_score_discontent', 'my_add_score_comment',
      #     'my_award_1like', 'my_award_3likes', 'my_award_5likes', 'my_award_15likes', 'my_award_50likes',
      #     'my_award_1imperfection', 'my_award_3imperfection', 'my_award_5imperfection', 'my_award_15imperfection',
      #     'my_award_1innovation', 'my_award_3innovation', 'my_award_5innovation', 'my_award_15innovation',
      #     'my_award_100points', 'my_award_500points', 'my_award_1000points', 'my_award_3000points', 'my_add_score_discontent_improve'
      #   'fa fa-trophy '
      # when 'life_tape_comment_discuss_status', 'life_tape_comment_approve_status', 'my_life_tape_comment_approve_status'
      #   'fa color-teal  fa-exclamation'
      # when 'my_discontent_comment_discuss_status', 'discontent_comment_discuss_status', 'discontent_post_comment_stat', 'discontent_post_discuss_status',
      #     'discontent_comment_approve_status', 'discontent_post_approve_status'
      #   'fa color-red  fa-exclamation'
      # when 'concept_comment_discuss_status', 'concept_post_discuss_status', 'concept_comment_approve_status', 'concept_post_approve_status'
      #   'fa color-orange  fa-exclamation'
      # when 'plan_comment_discuss_status', 'plan_comment_approve_status'
      #   'fa fa-exclamation color-green'
      # when 'essay_comment_discuss_status', 'essay_comment_approve_stat'
      #   'fa fa-exclamation'
      # when 'essay_post_save'
      #   'fa fa-plus'
      # when 'essay_post_update'
      #   'fa fa-edit'
      # when 'essay_comment_save'
      #   'fa fa-comment'
      # when 'discontent_post_discuss_status'
      #   'fa fa-exclamation color-red'
      # when 'my_concept_note'
      #   'fa color-orange fa-hand-o-up'
      # when 'my_discontent_note'
      #   'fa color-red fa-hand-o-up'
      # when 'my_life_tape_comment'
      #   'fa color-teal fa-reply'
      # when 'reply_discontent_comment'
      #   'fa color-red fa-reply'
      #
      # when 'knowbase_edit'
      #   'fa fa-plus'
    end
  end

  def journal_parser(j, project)
    case j.type_event
      #COLLECT INFO
      # when 'core_aspect_comment_save'
      #   "добавил(а) комментарий: '#{j.body} ...' к аспекту:  "+ link_to("#{j.body2}", "/project/#{project}/collect_info/posts/?asp=#{j.first_id}&req_comment=#{j.second_id}#comment_#{j.second_id}")
      # when 'core_aspect_post_save'
      #   'добавил(а) аспект '+ link_to("#{j.body}..", "/project/#{project}/collect_info/posts/#{j.first_id}")
      # when 'my_core_aspect_comment'
      #   "добавил(а) комментарий: '#{j.body}'"+ link_to(' к вашему аспекту ', "/project/#{project}/collect_info/posts?asp=#{j.first_id}&viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}")
      # when 'reply_core_aspect_comment'
      #   "добавил(а) комментарий: '#{j.body}'"+ link_to(" в ответ на ваш '#{j.body2}'", "/project/#{project}/collect_info/posts?asp=#{j.first_id}&viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}")
      # when 'core_aspect_comment_discuss_stat'
      #   "выделил(а) комментарий: '#{j.body}'"+ link_to(' к аспекту ', "/project/#{project}/collect_info/posts?asp=#{j.first_id}&req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как требующий обсуждения'
      # when 'my_core_aspect_comment_discuss_stat'
      #   "выделил(а) ваш комментарий: '#{j.body}'"+ link_to(' к аспекту ', "/project/#{project}/collect_info/posts?asp=#{j.first_id}&viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как требующий обсуждения'
      #
      # when 'core_aspect_post_approve_status'
      #   'выделил(а) аспект  ' + link_to("#{j.body}", "/project/#{project}/collect_info/posts/#{j.first_id}?asp=#{j.first_id}") + ' как важный'
      # when 'my_core_aspect_post_approve_status'
      #   'выделил(а) ваш аспект  ' + link_to("#{j.body}", "/project/#{project}/collect_info/posts/#{j.first_id}?asp=#{j.first_id}&viewed=true") + ' как важный'
      # when 'core_aspect_comment_approve_status'
      #   "выделил(а) комментарий: '#{j.body}'"+ link_to(' к аспекту ', "/project/#{project}/collect_info/posts?asp=#{j.first_id}&req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      # when 'my_core_aspect_comment_approve_status'
      #   "выделил(а) ваш комментарий: '#{j.body}'"+ link_to(' к аспекту ', "/project/#{project}/collect_info/posts?asp=#{j.first_id}&viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'

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

      # DISCONTENTS
      # when 'discontent_comment_save'
      #   "добавил(а) комментарий: '#{j.body}'"+ ' к несовершенству '+ link_to("#{j.body2} ... ", "/project/#{project}/discontent/posts/#{j.first_id}?req_comment=#{j.second_id}#comment_#{j.second_id}")
      # when 'discontent_post_save'
      #   if j.anonym
      #     " #{t('journal.add_anonym_discontent')} #{link_to("#{j.body}", "/project/#{project}/discontent/posts/#{j.first_id}")}"
      #   else
      #     'добавил(а) несовершенство  ' + link_to("#{j.body}", "/project/#{project}/discontent/posts/#{j.first_id}")
      #   end
      #
      # when 'discontent_post_update'
      #   if j.anonym
      #     ' анонимное несовершенство отредактировано ' + link_to("#{j.body}", "/project/#{project}/discontent/posts/#{j.first_id}")
      #   else
      #     'отредактировал(а) несовершенство '+ link_to("#{j.body}...", "/project/#{project}/discontent/posts/#{j.first_id}")
      #   end
      # when 'my_discontent_comment'
      #   "добавил(а) комментарий '#{j.body}...' к вашему несовершенству "+ link_to(j.body2, "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}")
      # when 'reply_discontent_comment'
      #   "добавил(а) комментарий '#{j.body}...' в ответ на ваш "+ link_to(j.body2, "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}")
      # when 'my_add_score_discontent'
      #   "вы получили  #{j.body} баллов за несовершенство "+ link_to(j.body2, "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true")
      # when 'my_add_score_discontent_improve'
      #   "вы получили  #{j.body} баллов за то, что вашу проблему доработали в несовершенство "+ link_to(j.body2, "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true")
      # when 'my_discontent_note'
      #   s = j.body.split(':')
      #   "добавил(а) замечание  '#{j.body}...' к "+ link_to('вашему несовершенству', "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true")
      # when 'discontent_post_discuss_status'
      #   'выделил(а) несовершенство  ' + link_to("#{j.body}", "/project/#{project}/discontent/posts/#{j.first_id}") + ' как требующее обсуждения'
      # when 'my_discontent_post_discuss_status'
      #   'выделил(а) ваше несовершенство  ' + link_to("#{j.body}", "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true") + ' как требующее обсуждения'
      # when 'discontent_comment_discuss_status'
      #   "выделил(а) комментарий '#{j.body}...' к несовершенству "+ link_to(j.body2, "/project/#{project}/discontent/posts/#{j.first_id}?req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как требующий обсуждения'
      # when 'my_discontent_comment_discuss_status'
      #   "выделил(а) ваш комментарий '#{j.body}...' к несовершенству "+ link_to(j.body2, "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как требующий обсуждения'
      # when 'discontent_post_approve_status'
      #   'выделил(а) несовершенство  ' + link_to("#{j.body}", "/project/#{project}/discontent/posts/#{j.first_id}") + ' как важное'
      # when 'my_discontent_post_approve_status'
      #   'выделил(а) ваше несовершенство  ' + link_to("#{j.body}", "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true") + ' как важное'
      # when 'discontent_comment_approve_status'
      #   "выделил(а) комментарий '#{j.body}...' к несовершенству "+ link_to(j.body2, "/project/#{project}/discontent/posts/#{j.first_id}?req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      # when 'my_discontent_comment_approve_status'
      #   "выделил(а) ваш комментарий '#{j.body}...' к несовершенству "+ link_to(j.body2, "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'


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









      # when 'concept_comment_save'
      #   "добавил(а) комментарий: '#{j.body}'"+ ' к нововведению '+ link_to("#{j.body2} ... ", "/project/#{project}/concept/posts/#{j.first_id}?req_comment=#{j.second_id}#comment_#{j.second_id}")
      # when 'concept_post_save'
      #   'добавил(а) нововведение  ' + link_to("#{j.body}", "/project/#{project}/concept/posts/#{j.first_id}")
      # when 'concept_post_update'
      #   'отредактировал(а) нововведение '+ link_to("#{j.body}...", "/project/#{project}/concept/posts/#{j.first_id}")
      # when 'my_concept_comment'
      #   "добавил(а) комментарий '#{j.body}...' к вашему нововведению "+ link_to(j.body2, "/project/#{project}/concept/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}")
      # when 'reply_concept_comment'
      #   "добавил(а) комментарий '#{j.body}...' в ответ на ваш "+ link_to(j.body2, "/project/#{project}/concept/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}")
      #
      # when 'my_add_score_concept'
      #   "вы получили  #{j.body} баллов за нововведение "+ link_to(j.body2, "/project/#{project}/concept/posts/#{j.first_id}?viewed=true")
      # when 'my_add_score_concept_improve'
      #   "вы получили  #{j.body} баллов за то, что вашу идею доработали в нововведение "+ link_to(j.body2, "/project/#{project}/concept/posts/#{j.first_id}?viewed=true")
      #
      # when 'my_concept_note'
      #   s = j.body.split(':')
      #   "добавил(а) замечание  '#{j.body}...' к "+ link_to('вашему нововведению', "/project/#{project}/concept/posts/#{j.first_id}?viewed=true")
      # when 'concept_post_discuss_status'
      #   'выделил(а) нововведение  ' + link_to("#{j.body}", "/project/#{project}/concept/posts/#{j.first_id}") + ' как требующее обсуждения'
      # when 'my_concept_post_discuss_status'
      #   'выделил(а) ваше нововведение  ' + link_to("#{j.body}", "/project/#{project}/concept/posts/#{j.first_id}?viewed=true") + ' как требующее обсуждения'
      # when 'concept_comment_discuss_status'
      #   "выделил(а) комментарий '#{j.body}...' к нововведению "+ link_to(j.body2, "/project/#{project}/concept/posts/#{j.first_id}?req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как требующий обсуждения'
      # when 'my_concept_comment_discuss_status'
      #   "выделил(а) ваш комментарий '#{j.body}...' к нововведению "+ link_to(j.body2, "/project/#{project}/concept/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как требующий обсуждения'
      # when 'concept_post_approve_status'
      #   'выделил(а) нововведение  ' + link_to("#{j.body}", "/project/#{project}/concept/posts/#{j.first_id}") + ' как важное'
      # when 'my_concept_post_approve_status'
      #   'выделил(а) ваше нововведение  ' + link_to("#{j.body}", "/project/#{project}/concept/posts/#{j.first_id}?viewed=true") + ' как важное'
      # when 'concept_comment_approve_status'
      #   "выделил(а) комментарий '#{j.body}...' к нововведению "+ link_to(j.body2, "/project/#{project}/concept/posts/#{j.first_id}?req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      # when 'my_concept_comment_approve_status'
      #   "выделил(а) ваш комментарий '#{j.body}...' к нововведению "+ link_to(j.body2, "/project/#{project}/concept/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'



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

      # PLANS
      # when 'plan_comment_save'
      #   "добавил(а) комментарий: '#{j.body}'"+ ' к проекту '+ link_to("#{j.body2} ... ", "/project/#{project}/plan/posts/#{j.first_id}?req_comment=#{j.second_id}#comment_#{j.second_id}")
      # when 'plan_post_save'
      #   'добавил(а) проект  ' + link_to("#{j.body}", "/project/#{project}/plan/posts/#{j.first_id}")
      # when 'plan_post_update'
      #   'отредактировал(а) проект '+ link_to("#{j.body}...", "/project/#{project}/plan/posts/#{j.first_id}")
      # when 'my_plan_comment'
      #   "добавил(а) комментарий '#{j.body}...' к вашему проекту "+ link_to(j.body2, "/project/#{project}/plan/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}")
      # when 'reply_plan_comment'
      #   "добавил(а) комментарий '#{j.body}...' в ответ на ваш "+ link_to(j.body2, "/project/#{project}/plan/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}")
      # when 'my_plan_note'
      #   "добавил(а) замечание  '#{j.body}...' к вашему проекту "+ link_to(j.body2, "/project/#{project}/plan/posts/#{j.first_id}?viewed=true")
      # when 'plan_comment_discuss_status'
      #   "выделил(а) комментарий '#{j.body}...' к проекту "+ link_to(j.body2, "/project/#{project}/plan/posts/#{j.first_id}?req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как требующий обсуждения'
      # when 'my_plan_comment_discuss_status'
      #   "выделил(а) ваш комментарий '#{j.body}...' к проекту "+ link_to(j.body2, "/project/#{project}/plan/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как требующий обсуждения'
      # when 'plan_comment_approve_status'
      #   "выделил(а) комментарий '#{j.body}...' к проекту "+ link_to(j.body2, "/project/#{project}/plan/posts/#{j.first_id}?req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      # when 'my_plan_comment_approve_status'
      #   "выделил(а) ваш комментарий '#{j.body}...' к проекту "+ link_to(j.body2, "/project/#{project}/plan/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'


      # ESSAY
      when 'essay_comment_save'
        "добавил(а) комментарий: '#{j.body}'"+ ' к рефлексии '+ link_to("#{j.body2 == '' ? 'подробнее' : j.body2} ... ", "/project/#{project}/stage/1/essay/posts/#{j.first_id}?req_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'essay_post_save'
        'добавил(а) свою рефлексию об этапе  ' + link_to("#{j.body == '' ? 'подробнее' : j.body}", "/project/#{project}/stage/1/essay/posts/#{j.first_id}")
      when 'essay_post_update'
        'отредактировал(а) рефлексию '+ link_to("#{j.body == '' ? 'подробнее' : j.body}...", "/project/#{project}/stage/1/essay/posts/#{j.first_id}")
      when 'my_essay_comment'
        "добавил(а) комментарий '#{j.body}...' к вашей рефлексии "+ link_to("#{j.body2 == '' ? 'подробнее' : j.body2}", "/project/#{project}/stage/1/essay/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'reply_essay_comment'
        "добавил(а) комментарий '#{j.body}...' в ответ на ваш "+ link_to("#{j.body2 == '' ? 'подробнее' : j.body2}", "/project/#{project}/stage/1/essay/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}")
      when 'essay_comment_discuss_status'
        "выделил(а) комментарий '#{j.body}...' к рефлексии "+ link_to("#{j.body2 == '' ? 'подробнее' : j.body2}", "/project/#{project}/stage/1/essay/posts/#{j.first_id}?req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как требующий обсуждения'
      when 'my_essay_comment_discuss_status'
        "выделил(а) ваш комментарий '#{j.body}...' к рефлексии "+ link_to("#{j.body2 == '' ? 'подробнее' : j.body2}", "/project/#{project}/stage/1/essay/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как требующий обсуждения'
      when 'essay_comment_approve_status'
        "выделил(а) комментарий '#{j.body}...' к рефлексии "+ link_to("#{j.body2 == '' ? 'подробнее' : j.body2}", "/project/#{project}/stage/1/essay/posts/#{j.first_id}?req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      when 'my_essay_comment_approve_status'
        "выделил(а) ваш комментарий '#{j.body}...' к рефлексии "+ link_to("#{j.body2 == '' ? 'подробнее' : j.body2}", "/project/#{project}/stage/1/essay/posts/#{j.first_id}?viewed=true&req_comment=#{j.second_id}#comment_#{j.second_id}") + ' как важный'
      # AWARDS
      when 'award_1like', 'award_3likes', 'award_5likes', 'award_15likes', 'award_50likes',
          'award_1imperfection', 'award_3imperfection', 'award_5imperfection', 'award_15imperfection',
          'award_1innovation', 'award_3innovation', 'award_5innovation', 'award_15innovation',
          'award_100points', 'award_500points', 'award_1000points', 'award_3000points'
        "заработал(а) достижение '#{j.body}'"
      when 'my_award_1like', 'my_award_3likes', 'my_award_5likes', 'my_award_15likes', 'my_award_50likes',
          'my_award_1imperfection', 'my_award_3imperfection', 'my_award_5imperfection', 'my_award_15imperfection',
          'my_award_1innovation', 'my_award_3innovation', 'my_award_5innovation', 'my_award_15innovation',
          'my_award_100points', 'my_award_500points', 'my_award_1000points', 'my_award_3000points'
        "вы заработали достижение '#{j.body}'! Продолжайте в том же духе!"
      when 'add_score_essay'
        'получил(а)  '+j.body+' баллов за эссе'
      when 'add_score'
        'получил(а)  '+j.body+' баллов за участие в сборе информации'
      when 'useful_comment'
        s = j.body.split(':')
        'получил(а) баллы за полезный комментарий '+ link_to("#{s[0]}...", "/project/#{project}/#{s[1]}")
      when 'useful_post'
        s = j.body.split(':')
        'получил(а) баллы за полезный материал '+ link_to("#{s[0]}...", "/project/#{project}/#{s[1]}")
      when 'add_score_anal'
        'получил 20 балов за аналитику '+ link_to('за комментарий к несовершенству', "/project/#{project}/discontent/status/0/aspect/0/posts/#{j.body}")
      when 'add_score_anal_concept_post'
        'получил 20 балов за аналитику '+ link_to('за комментарий к образу', "/project/#{project}/concept/status/0/posts/#{j.body}")
      when 'expert_news_post_save'
        'добавил  '+ link_to('новость', expert_news_post_path(project, j.body))
      when 'expert_news_comment_save'
        s = j.body.split(':')
        if s.length == 1
          'добавил комментарий к '+ link_to('новости', expert_news_post_path(project, j.body))
        else
          "добавил комментарий '#{s[0]}...' к "+ link_to('новости', expert_news_post_path(project, s[1]))
        end
      when 'estimate_comment_save'
        s = j.body.split(':')
        if s.length == 1
          'добавил комментарий к '+ link_to('оценке', "/project/#{project}/estimate/posts/#{j.body}")
        else
          "добавил комментарий '#{s[0]}...' к "+ link_to('оценке', "/project/#{project}/estimate/posts/#{s[1]}")
        end
      when 'my_add_score_comment'
        s = j.body.split(':')
        "вы получили #{s[0]} баллов за полезный комментарий!"
      # "вы получили #{s[0]} баллов "  +  link_to("за полезный комментарий ", "/project/#{project}/#{s[1].gsub('#', "?viewed=#{j.id}#")}" )
      when 'my_invite_to_group'
        link_to j.body, group_path(j.project_id, j.first_id)
      when 'my_call_to_group'
        link_to j.body, group_path(j.project_id, j.first_id)
      when 'my_assigned_task'
        link_to j.body, group_path(j.project_id, j.first_id)
      when 'knowbase_edit'
        'обновил базу знаний по аспекту ' +link_to(j.body, "/project/#{project}/collect_info/posts?asp=#{j.first_id}")
      when 'my_new_expert_news'
        "экспертом добавлена новость #{link_to j.body, news_path(project, j.first_id)}"
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
