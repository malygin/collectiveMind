module ApplicationHelper
	
	def cp(path)
		cur_path = request.env['REQUEST_PATH'] 
		if current_page?(path) or ((cur_path.include?('life_tape') or cur_path == '/') and path.include?('life_tape') )
  			'current'
  		end
	end

	def image_for_stages(image, path)
		cur_path = request.env['REQUEST_PATH'] 	
		if current_page?(path) or ((cur_path.include?('life_tape') or cur_path == '/') and path.include?('life_tape') )
          return image+'green.png'  
		else
		  return  image+'.png' 
		end
	end
end
