class Plan::PostAction < ActiveRecord::Base
  belongs_to :plan_post_aspect, class_name: 'Plan::PostAspect', foreign_key: :plan_post_aspect_id

  has_many :plan_post_action_resources, class_name: 'Plan::PostActionResource', foreign_key: :post_action_id
  has_many :plan_post_resources, class_name: 'Plan::PostResource', foreign_key: :post_id
end
