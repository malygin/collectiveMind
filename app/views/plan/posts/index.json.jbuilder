json.array! @posts do |item|
  json.id item.id
  json.title item.name.present? ? item.name : 'Проект без названия'
  json.content trim_content(item.content, 200)
  json.approve_status item.approve_status
  json.useful item.useful
  json.admin_panel boss?
  json.user item.user.to_s
  json.user_avatar_url user_image_path(item.user.try(:avatar))
  json.user_avatar_alt user_image_alt(item.user.try(:avatar))
  json.post_date Russian.strftime(item.created_at, '%d.%m.%Y')
  json.project_id item.project_id
  json.sort_date item.created_at.to_datetime.to_f
  json.sort_comment item.last_comment.present? ? item.last_comment.created_at.to_datetime.to_f : 0
  json.active_comments item.comments.after_last_visit(last_time_visit_page).size > 0
  json.last_time_visit last_time_visit_page
  json.count_comments item.comments.count
  json.count_likes item.users_pro.count
  json.count_dislikes item.users_against.count
  # json.comments item.comments.includes(:user).preview do |comment|
  #   json.id comment.id
  #   json.date Russian.strftime(comment.created_at, '%k:%M %d.%m.%y')
  #   json.user comment.user.to_s
  #   json.content trim_content(comment.content, 100)
  # end
end
