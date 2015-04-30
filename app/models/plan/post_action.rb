class Plan::PostAction < ActiveRecord::Base
  belongs_to :plan_post_novation, class_name: 'Plan::PostNovation', foreign_key: :plan_post_aspect_id

  # has_many :plan_post_resources, class_name: 'Plan::PostResource', foreign_key: :post_id
end
