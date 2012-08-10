module UsersHelper
	def gravatar_for(user, options = {:size =>50})
		gravatar_image_tag(user.email.downcase, :alt => user.name,
			:class =>'gravatar', :gravatar => options)
	end

	def available_form_adding_frustration?(user)
		signed_in? and current_user == user  and current_user.frustrations.count<Settings.max_frustration 
	end
end
