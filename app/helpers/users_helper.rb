module UsersHelper
  def available_form_adding_frustration?(user)
    signed_in? and current_user == user and current_user.frustrations.count < Settings.max_frustration
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

  def club_status_show_user(user)
    case user.type_user
      when 4, 7
        content_tag(:span, 'RC', class: 'label label-primary')
      when 5
        content_tag(:span, 'RC WATCHER', class: 'label label-warning')
      else
        content_tag(:b, 'RC?', class: 'color-orange', id: "club_status_tag_#{user.id}")
    end
  end

  def club_status(user)
    case user.type_user
      when 4, 7
        content_tag(:b, 'RC', class: 'color-teal', style: 'text-decoration:none;', id: "club_status_tag_#{user.id}")
      when 5
        content_tag(:b, 'RC WATCHER', class: 'color-red', style: 'text-decoration:none;', id: "club_status_tag_#{user.id}")
      else
        content_tag(:b, 'RC?', class: 'color-orange', style: 'text-decoration:none;', id: "club_status_tag_#{user.id}")
    end
  end
end
