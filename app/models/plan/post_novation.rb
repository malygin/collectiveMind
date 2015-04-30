class Plan::PostAspect < ActiveRecord::Base
  belongs_to :novation_post, class_name: 'Novation::Post'
  belongs_to :plan_post, class_name: 'Plan::Post', foreign_key: :plan_post_id

  has_many :plan_post_actions, -> { order :date_begin }, class_name: 'Plan::PostAction', foreign_key: :plan_post_aspect_id

end
