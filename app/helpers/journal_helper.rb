# encoding: utf-8
module JournalHelper
  def journal_icon(j)
    case j.type_event

      when 'plan_post_save'
        'fa fa-plus color-green'
      when 'plan_post_update'
        'fa fa-edit color-green'
      when 'plan_comment_save'
        'fa fa-comment color-green'

      when 'concept_post_save'
        'fa fa-plus color-orange'
      when 'concept_post_update'
        'fa fa-edit color-orange'
      when 'concept_comment_save'
        'fa fa-comment color-orange'

      when 'discontent_post_save'
        'fa fa-plus color-red'
      when 'discontent_post_update'
        'fa fa-edit color-red'
      when 'discontent_comment_save'
        'fa fa-comment color-red'

      when 'life_tape_post_save'
        'fa fa-plus color-teal'
      when 'life_tape_comment_save'
        'fa fa-comment color-teal'
      when  'award_1like', 'award_3likes','award_5likes','award_15likes','award_50likes',
          'award_1imperfection', 'award_3imperfection', 'award_5imperfection', 'award_15imperfection'
        'fa fa-trophy '
    end
  end
	def journal_parser(j, project)
		case j.type_event

      #LIFETAPE
      when 'life_tape_comment_save'
        "добавил комментарий: '#{j.body} ...' к теме:  "+  link_to("#{j.body2}", "/project/#{project}/life_tape/posts/?asp=#{j.first_id}#comment_#{j.second_id}" )

      when 'life_tape_post_save'
        'добавил тему '+  link_to("#{j.body}..", "/project/#{project}/life_tape/posts/#{j.first_id}" )

      when 'my_life_tape_comment'
        "добавил комментарий: '#{j.body}'"+  link_to(' к вашей теме ', "/project/#{project}/life_tape/posts?asp=#{j.first_id}&viewed=true#comment_#{j.second_id}")

      when 'reply_life_tape_comment'
        "добавил комментарий: '#{j.body}'"+  link_to(" в ответ на ваш '#{j.body2}'", "/project/#{project}/life_tape/posts?asp=#{j.first_id}&viewed=true#comment_#{j.second_id}")

      # DISCONTENTS
      when 'discontent_comment_save'
        "добавил(а) комментарий: '#{j.body}'"+ ' к несовершенству '+  link_to("#{j.body2} ... ", "/project/#{project}/discontent/posts/#{j.first_id}#comment_#{j.second_id}")

      when 'discontent_post_save'
        'добавил(а) несовершенство  ' + link_to("#{j.body}", "/project/#{project}/discontent/posts/#{j.first_id}")

      when 'discontent_post_update'
        'отредактировал(а) несовершенство '+ link_to("#{j.body}...", "/project/#{project}/discontent/posts/#{j.first_id}")

      when 'my_discontent_comment'
        "добавил(а) комментарий '#{j.body}...' к вашему несовершенству "+  link_to(j.body2, "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true#comment_#{j.second_id}")

      when 'reply_discontent_comment'
        "добавил(а) комментарий '#{j.body}...' в ответ на ваш "+  link_to( j.body2, "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true#comment_#{j.second_id}")

      when 'my_add_score_discontent'
        "вы получили  #{j.body} баллов за несовершенство "+  link_to( j.body2, "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true")

      when 'my_add_score_discontent_improve'
        "вы получили  #{j.body} баллов за то, что вашу проблему доработали в несовершенство "+  link_to( j.body2, "/project/#{project}/discontent/posts/#{j.first_id}?viewed=true")

      # CONCEPTS
      when 'concept_comment_save'
        "добавил(а) комментарий: '#{j.body}'"+ ' к нововведению '+  link_to("#{j.body2} ... ", "/project/#{project}/concept/posts/#{j.first_id}#comment_#{j.second_id}")

      when 'concept_post_save'
        'добавил(а) нововведение  ' + link_to("#{j.body}", "/project/#{project}/concept/posts/#{j.first_id}")

      when 'concept_post_update'
        'отредактировал(а) нововведение '+ link_to("#{j.body}...", "/project/#{project}/concept/posts/#{j.first_id}")

      when 'my_concept_comment'
        "добавил(а) комментарий '#{j.body}...' к вашему нововведению "+  link_to(j.body2, "/project/#{project}/concept/posts/#{j.first_id}?viewed=true#comment_#{j.second_id}")

      when 'reply_concept_comment'
        "добавил(а) комментарий '#{j.body}...' в ответ на ваш "+  link_to( j.body2, "/project/#{project}/concept/posts/#{j.first_id}?viewed=true#comment_#{j.second_id}")

      # PLANS
      when 'plan_comment_save'
        "добавил(а) комментарий: '#{j.body}'"+ ' к проекту '+  link_to("#{j.body2} ... ", "/project/#{project}/plan/posts/#{j.first_id}#comment_#{j.second_id}")

      when 'plan_post_save'
        'добавил(а) проект  ' + link_to("#{j.body}", "/project/#{project}/plan/posts/#{j.first_id}")

      when 'plan_post_update'
        'отредактировал(а) проект '+ link_to("#{j.body}...", "/project/#{project}/plan/posts/#{j.first_id}")

      when 'my_plan_comment'
        "добавил(а) комментарий '#{j.body}...' к вашему проекту "+  link_to(j.body2, "/project/#{project}/plan/posts/#{j.first_id}?viewed=true#comment_#{j.second_id}")

      when 'reply_plan_comment'
        "добавил(а) комментарий '#{j.body}...' в ответ на ваш "+  link_to( j.body2, "/project/#{project}/plan/posts/#{j.first_id}?viewed=true#comment_#{j.second_id}")


      # AWARDS

      when 'award_1like', 'award_3likes','award_5likes','award_15likes','award_50likes',
          'award_1imperfection', 'award_3imperfection', 'award_5imperfection', 'award_15imperfection'
          "заработал(а) достижение '#{j.body}'"

      when 'my_award_1like', 'my_award_3likes', 'my_award_5likes','my_award_15likes','my_award_50likes',
        'my_award_1imperfection', 'my_award_3imperfection', 'my_award_5imperfection', 'my_award_15imperfection'
        "вы заработали достижение '#{j.body}'! Продолжайте в том же духе!"


      when 'add_score_essay'
				'получил(а)  '+j.body+' баллов за эссе'
      when 'add_score'
				'получил(а)  '+j.body+' баллов за участие в сборе информации'

      when 'useful_comment'
        s = j.body.split(':')
        'получил(а) баллы за полезный комментарий '+ link_to("#{s[0]}...", "/project/#{project}/#{s[1]}" )
     when 'useful_post'
        s = j.body.split(':')
        'получил(а) баллы за полезный материал '+ link_to("#{s[0]}...", "/project/#{project}/#{s[1]}" )

      when 'add_score_anal'
				'получил 20 балов за аналитику '+ link_to('за комментарий к несовершенству', "/project/#{project}/discontent/status/0/aspect/0/posts/#{j.body}")
      when 'add_score_anal_concept_post'
				'получил 20 балов за аналитику '+ link_to('за комментарий к образу', "/project/#{project}/concept/status/0/posts/#{j.body}")

      when 'expert_news_post_save'
				'добавил  '+ link_to('новость', expert_news_post_path(project, j.body))

      when 'expert_news_comment_save'
        s = j.body.split(':')
        if s.length == 1
				'добавил комментарий к '+  link_to('новости', expert_news_post_path(project, j.body))
        else
          "добавил комментарий '#{s[0]}...' к "+  link_to('новости', expert_news_post_path(project, s[1]))
        end

       when 'estimate_comment_save'
        s = j.body.split(':')
        if s.length == 1
          'добавил комментарий к '+  link_to('оценке', "/project/#{project}/estimate/posts/#{j.body}")
        else
          "добавил комментарий '#{s[0]}...' к "+  link_to('оценке', "/project/#{project}/estimate/posts/#{s[1]}")

        end

      when 'my_add_score_comment'
        s = j.body.split(':')
        "вы получили #{s[0]} баллов за полезный комментарий!"
        # "вы получили #{s[0]} баллов "  +  link_to("за полезный комментарий ", "/project/#{project}/#{s[1].gsub('#', "?viewed=#{j.id}#")}" )

      when 'my_discontent_note'
        s = j.body.split(':')
        "добавил(а) замечание  '#{s[0]}...' к "+  link_to('вашему несовершенству', "/project/#{project}/discontent/posts/#{s[1]}?viewed=#{j.id}")
      when 'my_concept_note'
        s = j.body.split(':')
        "добавил(а) замечание  '#{s[0]}...' к "+  link_to('вашему нововведению', "/project/#{project}/concept/posts/#{s[1]}?viewed=#{j.id}")
			else
				'что то другое'
		end 
	end
end
