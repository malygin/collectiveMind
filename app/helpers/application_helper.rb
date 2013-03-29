# encoding: utf-8

module ApplicationHelper
##### status 
# 0 - prepare to procedure
# 1 - life_tape
# 2 - vote fo aspects
# 3 - Discontent
# 4 - voting for Discontent
# 5 - Concept 
# 6 - voiting for Concept
# 7 - plan
# 8 - voiting for plan
# 9 - estimate
# 10 - final vote
# 11 - wait for	
	def cp( stage)
		if stage =='life_tape' and ( [0,1].include? @project.status)
			'current'
  		end
	end

	def stage_vote?(stage)
		if stage =='life_tape' and (@project.status==2)
			true
		else
			false
		end

  		
	end

	def image_for_stages(image,  stage)
		if stage =='life_tape' and ([0,1].include? @project.status)    
		    return image+'green.png'  
		else
		  return  image+'.png' 
		end
	end

def  status_title(pr)
		case pr
			when 0
				'готовится к процедуре'
			when 1
				'сбор информации'
			when 2
				'голосование за аспекты и рефлексия'
			when 20
				'завершена'
		

			else
				'завершена'
		end 
	end

	def  type_title(pr)
		case pr
			when 0
				'открыта с возможностью участвовать'
			when 1
				'открыта для просмотра'
			when 2
				'закрыта'
		

			else
				'закрыта'
		end 
	end

	def count_available_voiting(n)
		5-n
	end

	def can_vote?(this_v, all_v)
		this_v<1 and all_v<5
	end

end
