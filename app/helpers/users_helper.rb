
module UsersHelper
	def gravatar_for(user, options = {:size =>58})

		# if user.login.nil?
		# 	return image_tag('http://oec-static.main.sgu.ru/storage/oec-j2ee6/ROOT/userFiles/avatars/defaultAvatarSmall.jpg')
		# else
		# 	res = Net::HTTP.get_response(URI.parse('http://oec-static.main.sgu.ru/storage/oec-j2ee6/ROOT/userFiles/avatars/'+user.login+'_small.jpg'))
		# 	if res.code == '404' 
		# 		return image_tag('http://oec-static.main.sgu.ru/storage/oec-j2ee6/ROOT/userFiles/avatars/defaultAvatarSmall.jpg')
		# 	else 
		# 		return image_tag('http://oec-static.main.sgu.ru/storage/oec-j2ee6/ROOT/userFiles/avatars/'+user.login+'_small.jpg')
		# 	end
		# end
		# gravatar_image_tag(user.email.downcase, :alt => user.name, :align => 'left',
		# 	:class =>'avatar', :gravatar => options)
		if user.login.nil?
			image_tag('http://oec-static.main.sgu.ru/storage/oec-j2ee6/ROOT/userFiles/avatars/defaultAvatarSmall.jpg', :class =>'avatar')
		else
			image_tag('http://oecdo.sgu.ru/ImageServlet?user='+user.login, :class =>'avatar')
		end
	end

	def available_form_adding_frustration?(user)
		signed_in? and current_user == user  and current_user.frustrations.count<Settings.max_frustration 
	end
end
