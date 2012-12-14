# encoding: utf-8ы
module JournalHelper

	def journal_parser(j)
		case j.type_event
			when 'concept_post_save'
				'добавил  '+ link_to('концепцию', concept_post_path(j.body))
			when 'concept_comment_save'
				'добавил комментарий к '+  link_to('концепции', concept_post_path(j.body))
			when 'life_tape_comment_save'
				'добавил комментарий к '+  link_to('идее', life_tape_post_path(j.body))
			when 'life_tape_post_save'
				'добавил '+  link_to('идею', life_tape_post_path(j.body))				
			when 'concept_post_update'
				'отредактировал '+  link_to('концепцию', concept_post_path(j.body))
			when 'question_save'
				'задал '+  link_to('вопрос', question_path(j.body))			
			else
				'что то другое'
		end 
	end
end
