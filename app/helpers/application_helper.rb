module ApplicationHelper
	
	def cp(path, stage)
		cur_path = request.env['REQUEST_PATH']
		if current_page?(path) or ((cur_path.include?(stage)) and path.include?(stage)) or
			(Settings.current_stage == stage and cur_path == '/')
			'current'
  		end
	end

	def cp_frustration(path)
		cur_path = request.env['REQUEST_PATH']
		if current_page?(path)
			'current'
		end
	end


	def image_for_stages(image, path, stage)
		cur_path = request.env['REQUEST_PATH'] 	
		if current_page?(path) or ((cur_path.include?(stage)) and path.include?(stage)) or
		   (Settings.current_stage == stage and cur_path == '/')        
		    return image+'green.png'  
		else
		  return  image+'.png' 
		end
	end

	def frustration_path?
		cur_path = request.env['REQUEST_PATH']
		cur_path.include?('frustrations')
	end


end
