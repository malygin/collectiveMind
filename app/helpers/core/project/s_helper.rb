# encoding: utf-8

module Core::Project::SHelper
	def  status_title(pr)
		case pr
			when 0
				'готовится к процедуре'
			when 1
				'сбор информации'
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
end
