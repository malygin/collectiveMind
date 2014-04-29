# encoding: utf-8
module JournalHelper

	def journal_parser(j, project)
		case j.type_event
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
      when 'concept_post_save'
				'добавил  '+ link_to('нововведение', concept_post_path(project,j.body))
      when 'concept_comment_save'
        s = j.body.split(':')
        if s.length == 1
          'добавил комментарий к '+  link_to('нововведению', concept_post_path(project, j.body))
        else
          "добавил комментарий '#{s[0]}...' к "+  link_to('нововведению', concept_post_path(project, s[1]))
        end
			when 'expert_news_post_save'
				'добавил  '+ link_to('новость', expert_news_post_path(project, j.body))
      when 'expert_news_comment_save'
        s = j.body.split(':')
        if s.length == 1
				'добавил комментарий к '+  link_to('новости', expert_news_post_path(project, j.body))
        else
          "добавил комментарий '#{s[0]}...' к "+  link_to('новости', expert_news_post_path(project, s[1]))
        end
			
      when 'life_tape_comment_save'
        s = j.body.split(':')
        begin
          if LifeTape::Post.find(s[1].split('#')[0]).status ==0
            ": "+  link_to("'#{s[0]}...'", "/project/#{project}/life_tape/posts/#{s[1]}" )
          else
            false
          end
        rescue
          false
        end

      when 'life_tape_post_save'
        s = j.body.split(':')
        begin
          if LifeTape::Post.find(s[1]).status ==0
           ': '+  link_to("#{s[0]}...", "/project/#{project}/life_tape/posts/#{s[1]}" )
          else
            false
          end
        rescue
          false
        end

      when 'discontent_comment_save'
        s = j.body.split(':')
         if s.length == 1
           'добавил(а) комментарий к '+  link_to('несовершенству', "/project/#{project}/discontent/posts/#{j.body}")
         else
           "добавил(а) комментарий '#{s[0]}...' к "+  link_to('несовершенству', "/project/#{project}/discontent/posts/#{s[1]}")

         end
      when 'discontent_post_save'
        s = j.body.split(':')
				'добавил(а) несовершенство '+ link_to("#{s[0]}...", "/project/#{project}/discontent/posts/#{s[1]}")
      when 'discontent_post_update'
        s = j.body.split(':')
				'отредактировал(а) несовершенство '+ link_to("#{s[0]}...", "/project/#{project}/discontent/posts/#{s[1]}")
      when 'discontent_post_revision'
        'отправил на доработку ' +link_to('несовершенство', discontent_post_path(project,j.body))
      when 'discontent_post_acceptance'
        'принял ' +link_to('несовершенство', discontent_post_path(project,j.body))
      when 'discontent_post_rejection'
        'отклонил ' +link_to('несовершенство', discontent_post_path(project,j.body))
      when 'discontent_post_to_expert'
        'отправил эксперту ' +link_to('несовершенство', discontent_post_path(project,j.body))

      when 'concept_post_update'
				'отредактировал '+  link_to('нововведение', concept_post_path(project,j.body))
			when 'question_post_save'
				'задал '+  link_to('вопрос', question_post_path(project, j.body))		
      when 'question_comment_save'
        s = j.body.split(':')
        if s.length == 1
				'ответил   '+  link_to(' на вопрос', question_post_path(project, j.body))
        else
          "ответил '#{s[0]}...' "+  link_to('на вопрос', question_post_path(project, s[1]))

        end

			#when 'concept_post_revision'
			#	'отправил на доработку ' +link_to('образ', concept_post_path(project,j.body))
			#when 'concept_post_acceptance'
			#	'принял ' +link_to('образ', concept_post_path(project,j.body))
			#when 'concept_post_rejection'
			#	'отклонил ' +link_to('образ', concept_post_path(project,j.body))
			#when 'concept_post_to_expert'
			#	'отправил эксперту ' +link_to('образ', concept_post_path(project,j.body))
			
			when 'plan_post_save'
				'добавил  '+ link_to('проект', plan_post_path(project, j.body))
      when 'plan_comment_save'
        s = j.body.split(':')
        if s.length == 1
          'добавил комментарий к '+  link_to('проекту', "/project/#{project}/plan/posts/#{j.body}")
        else
          "добавил комментарий '#{s[0]}...' к "+  link_to('проекту', "/project/#{project}/plan/posts/#{s[1]}")

        end

       when 'estimate_comment_save'
        s = j.body.split(':')
        if s.length == 1
          'добавил комментарий к '+  link_to('оценке', "/project/#{project}/estimate/posts/#{j.body}")
        else
          "добавил комментарий '#{s[0]}...' к "+  link_to('оценке', "/project/#{project}/estimate/posts/#{s[1]}")

        end


      #when 'essay_post_save'
				#'добавил  '+ link_to('эссе', essay_post_path(project, 2, j.body))
      #when 'essay_comment_save'
      #  s = j.body.split(':')
      #  if s.length == 1
      #    'добавил комментарий   '+  link_to(' к эссе', question_post_path(project, j.body))
      #  else
      #    "добавил комментарий  '#{s[0]}...' "+  link_to('к эссе', "/project/#{project}/stage/2/essay/posts/#{s[1]}")
      #
      #  end
			when 'plan_post_update'
				'отредактировал '+  link_to('проект', plan_post_path(project, j.body))
			#when 'plan_post_revision'
			#	'отправил на доработку ' +link_to('проект', plan_post_path(j.body))
			#when 'plan_post_acceptance'
			#	'принял ' +link_to('проект', plan_post_path(j.body))
			#when 'plan_post_rejection'
			#	'отклонил ' +link_to('проект', plan_post_path(j.body))
			#when 'plan_post_to_expert'
			#	'отправил эксперту ' +link_to('проект', plan_post_path(j.body))
			#when 'estimate_post_save'
			#	'добавил к проекту ' +link_to('оценку', estimate_post_path(j.body))
			#when 'estimate_post_update'
			#	'отредактировал ' +link_to('оценку', estimate_post_path(j.body))
			#when 'estimate_comment_save'
			#	'добавил комментарий к ' +link_to('оценке', estimate_post_path(j.body))
			#when 'estimate_post_rejection'
			#	'отклонил ' +link_to('оценку', estimate_post_path(j.body))
			#when 'estimate_post_acceptance'
			#	'принял ' +link_to('оценку', estimate_post_path(j.body))
      when 'my_life_tape_comment'
        s = j.body.split(':')
        ": '#{s[0]}...' к "+  link_to('вашей теме', "/project/#{project}/life_tape/posts/#{s[1]}" )
      when 'my_discontent_comment'
        s = j.body.split(':')
        "добавил(а) комментарий '#{s[0]}...' к "+  link_to('вашему несовершенству', "/project/#{project}/discontent/posts/#{s[1]}" )
      when 'my_concept_comment'
        s = j.body.split(':')
        "добавил(а) комментарий '#{s[0]}...' к "+  link_to('вашему нововведению', "/project/#{project}/concept/posts/#{s[1]}" )
			else
				'что то другое'
		end 
	end
end
