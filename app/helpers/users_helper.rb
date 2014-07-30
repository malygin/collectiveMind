
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
		
		#if user.avatar.file?
		image_tag user.avatar.url(:thumb), :class =>'avatar'
		#else
		#	if user.login.nil?
		#		image_tag('http://oec-static.main.sgu.ru/storage/oec-j2ee6/ROOT/userFiles/avatars/defaultAvatarSmall.jpg', :class =>'media-object')
		#	else
		#		image_tag('http://oecdo.sgu.ru/ImageServlet?user='+user.login, :class =>'media-object')
		#	end
		#end
	end

	def available_form_adding_frustration?(user)
		signed_in? and current_user == user  and current_user.frustrations.count<Settings.max_frustration 
  end

  def set_class_for_top(number)
    if number <= 3
      'top3'
    elsif 3 < number && number <= 10
      'top10'
    else
      nil
    end
  end

  def club_toggle_user(user)
    case user.type_user
      when 4
        5
      when 5
        4
      else
        4
    end
  end

  def club_status_show_user(user)
    case user.type_user
      when 4,7
        content_tag(:span, 'RC',:class =>'label label-primary')
      when 5
        content_tag(:span, 'RC WATCHER',:class =>'label label-warning')
      else
        # content_tag(:b, 'RC?',:class =>'color-orange', :style => 'text-decoration:none;', :id => "club_status_tag_#{user.id}")
    end
  end

  def club_status(user)
    case user.type_user
      when 4,7
        content_tag(:b, 'RC',:class =>'color-teal', :style => 'text-decoration:none;', :id => "club_status_tag_#{user.id}")
      when 5
        content_tag(:b, 'RC WATCHER',:class =>'color-red', :style => 'text-decoration:none;', :id => "club_status_tag_#{user.id}")
      else
        content_tag(:b, 'RC?',:class =>'color-orange', :style => 'text-decoration:none;', :id => "club_status_tag_#{user.id}")
    end
  end

end
