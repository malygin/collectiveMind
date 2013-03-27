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
		if stage =='life_tape' and ( [0,1,2].include? @project.status)
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
		if stage =='life_tape' and (@project.status==0 or @project.status==1)    
		    return image+'green.png'  
		else
		  return  image+'.png' 
		end
	end




end
