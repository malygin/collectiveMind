module ApplicationHelper
	
	def cp(path, stage)
		if current_page?(path)
			'current'
  		end
	end




	def image_for_stages(image, path, stage)
		if current_page?(path)    
		    return image+'green.png'  
		else
		  return  image+'.png' 
		end
	end




end
