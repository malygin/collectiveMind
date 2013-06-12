# encoding: utf-8
module JournalHelper

	def journal_parser(j, project)
		case j.type_event
			when 'concept_post_save'
				'добавил  '+ link_to('концепцию', concept_post_path(j.body))
			when 'concept_comment_save'
				'добавил комментарий к '+  link_to('концепции', concept_post_path(j.body))
			when 'expert_news_post_save'
				'добавил  '+ link_to('новость', expert_news_post_path(j.body))
			when 'expert_news_comment_save'
				'добавил комментарий к '+  link_to('новости', expert_news_post_path(j.body))
			
			when 'life_tape_comment_save'
				'добавил комментарий к '+  link_to('записи', life_tape_post_path(project, j.body))
			when 'life_tape_post_save'
				'добавил '+  link_to('запись', life_tape_post_path(project, j.body))				
            
            when 'discontent_comment_save'
				'добавил комментарий к '+  link_to('недовольству', discontent_post_path(project, j.body))
			when 'discontent_post_save'
				'добавил '+  link_to('недовольство', discontent_post_path(project, j.body))				
			
			when 'concept_post_update'
				'отредактировал '+  link_to('концепцию', concept_post_path(j.body))
			when 'question_post_save'
				'задал '+  link_to('вопрос', question_post_path(project, j.body))		
			when 'question_comment_save'
				'ответил на  '+  link_to('вопрос', question_post_path(project, j.body))	
			when 'concept_post_revision'
				'отправил на доработку ' +link_to('концепцию', concept_post_path(j.body))
			when 'concept_post_acceptance'
				'принял ' +link_to('концепцию', concept_post_path(j.body))
			when 'concept_post_rejection'
				'отклонил ' +link_to('концепцию', concept_post_path(j.body))
			when 'concept_post_to_expert'	
				'отправил эксперту ' +link_to('концепцию', concept_post_path(j.body))
			
			when 'plan_post_save'
				'добавил  '+ link_to('проект', plan_post_path(j.body))
			when 'plan_comment_save'
				'добавил комментарий к '+  link_to('проекту', plan_post_path(j.body))
			when 'plan_post_update'
				'отредактировал '+  link_to('проект', plan_post_path(j.body))
			when 'plan_post_revision'
				'отправил на доработку ' +link_to('проект', plan_post_path(j.body))
			when 'plan_post_acceptance'
				'принял ' +link_to('проект', plan_post_path(j.body))
			when 'plan_post_rejection'
				'отклонил ' +link_to('проект', plan_post_path(j.body))
			when 'plan_post_to_expert'	
				'отправил эксперту ' +link_to('проект', plan_post_path(j.body))
			when 'estimate_post_save'	
				'добавил к проекту ' +link_to('оценку', estimate_post_path(j.body))
			when 'estimate_post_update'	
				'отредактировал ' +link_to('оценку', estimate_post_path(j.body))
			when 'estimate_comment_save'	
				'добавил комментарий к ' +link_to('оценке', estimate_post_path(j.body))
			when 'estimate_post_rejection'	
				'отклонил ' +link_to('оценку', estimate_post_path(j.body))
			when 'estimate_post_acceptance'	
				'принял ' +link_to('оценку', estimate_post_path(j.body))

			else
				'что то другое'
		end 
	end
end
