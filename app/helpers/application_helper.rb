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
	def menu_status(st)
		if request.fullpath.include? "status/#{st}" 
			'current'
		end
	end
	
	def cp( stage)
		if stage =='life_tape' and ( [0,1,2].include? @project.status)
			'current'
  		elsif stage == 'discontent' and ([3,4].include? @project.status)
  			'current'  		
  		elsif stage == 'concept' and ([5,6].include? @project.status)
  			'current'
  		elsif stage == 'plan' and (@project.status == 7)
  			'current' 		
  		elsif stage == 'estimate' and (@project.status == 8)
  			'current'
  		end
	end

	def stage_vote?(stage)
		if stage =='life_tape' and (@project.status==2)
			true
		elsif stage =='discontent' and (@project.status==4)
			true
		elsif stage =='concept' and (@project.status==6)
			true	
		elsif stage =='plan' and (@project.status==8)
			true
		else
			false
		end 		
	end

	def image_for_stages(image,  stage)
		if stage =='life_tape' and ([0,1,2].include? @project.status)    
		    return image+'green.png'  
		 elsif stage == 'discontent' and ([3,4].include? @project.status)
		    return image+'green.png' 		 
		elsif stage == 'concept' and ([5,6].include? @project.status)
		    return image+'green.png'  
		elsif stage == 'plan' and (@project.status == 7)
		    return image+'green.png'  		
		elsif stage == 'estimate' and (@project.status == 8)
		    return image+'green.png'  
		else
		  return  image+'.png' 
		end
	end

def  status_title(pr)
		case pr
			when 0
				'подготовка к процедуре'
			when 1
				'сбор информации'
			when 2
				'голосование за аспекты и рефлексия'			
			when 3
				'сбор несовершенств'
			when 4
				'голосование за недовольства и рефлексия'	
			when 5
				'формулирование образов'
			when 6
				'голосование за концепции и рефлексия'
			when 7 
				'создание проектов'
			when 8
				'голосование за проекты'
			when 9
				'выставление оценок'
			when 10 
				'итоговое голосование'

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

	def  type_project(pr)
		case pr
			when 0
				''
			when 1
				'(демонстрационная)'

		end 
	end


	def count_available_voiting(n)
		5-n
	end

	def can_vote?(this_v, all_v, all)
		this_v<1 and all_v!=0
  end

	def can_vote_cond?(this_v, all_v, all, dis)
		this_v<1 and all_v!=0  and dis.not_vote_for_other_post_aspects(current_user)
  end


def discontent_style_name(dis)
	case dis
		when 0 		
			'отсутствующий позитив'
		when 1
			'имеющийся негатив'
		else 
			'не определена'
		end
	end
end
