json.array! @posts do |item|
  json.id item.id
  json.title item.title
  json.content trim_content(item.content, 100)
  json.approve_status item.approve_status
  json.useful item.useful
  json.admin_panel boss?
  json.user item.user.to_s
  json.user_avatar item.user.try(:avatar) ? cl_image_path(item.user.try(:avatar)) : ActionController::Base.helpers.asset_path('no-ava.png')
  json.post_date Russian.strftime(item.created_at, '%d.%m.%Y')
  json.project_id item.project_id
  json.sort_date item.created_at.to_datetime.to_f
  json.sort_comment item.last_comment.present? ? item.last_comment.created_at.to_datetime.to_f : 0
  json.discontent_class post_discontent_classes(item)
  json.active_comments item.comments.after_last_visit(@last_time_visit).size > 0
  json.last_time_visit CGI.escape(@last_time_visit)
  json.count_comments item.comments.count
  json.count_likes item.users_pro.count
  json.count_dislikes item.users_against.count
  json.discontents item.concept_disposts do  |dispost|
    json.id dispost.id
    json.content trim_content(dispost.content, 30)
  end
  json.comments item.comments.preview do |comment|
    json.id comment.id
    json.date Russian.strftime(comment.created_at, '%k:%M %d.%m.%y')
    json.user comment.user.to_s
    json.content CGI.escapeHTML(comment.content)
  end
end
