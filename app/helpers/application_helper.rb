module ApplicationHelper
	
	def cp( stage)
		if stage =='life_tape' and (@project.status==0 or @project.status==1)
			'current'
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
