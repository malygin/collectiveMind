json.array! @posts do |item|
  json.id  item.id
  json.title item.title.present? ? item.title : 'Пакет без названия'
  json.content trim_content(item.project_change, 200)
  json.approve_status item.approve_status
  json.useful item.useful
  json.admin_panel boss?
  json.user item.user.to_s
  json.user_avatar item.user.try(:avatar) ? cl_image_path(item.user.try(:avatar))  : ActionController::Base.helpers.asset_path('no-ava.png')
  json.post_date Russian::strftime(item.created_at, '%d.%m.%Y')
  json.project_id item.project_id
  json.sort_date item.created_at.to_datetime.to_f
  json.sort_comment item.last_comment.present? ? item.last_comment.created_at.to_datetime.to_f : 0
  json.concept_class post_concept_classes(item)
  json.count_comments item.comments.count
  json.count_likes item.users_pro.count
  json.count_dislikes item.users_against.count
  json.concepts item.novation_concepts do  |concept|
    json.id concept.id
    json.content trim_content(concept.content, 30)
  end
  json.comments item.comments.preview do |comment|
    json.id  comment.id
    json.date Russian::strftime(comment.created_at, '%k:%M %d.%m.%y')
    json.user comment.user.to_s
    json.content trim_content(comment.content, 100)
  end
end
