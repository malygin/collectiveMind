class Plan::PostAction < ActiveRecord::Base
  attr_accessible :date_begin, :date_end, :desc, :name, :post_aspect, :status
  belongs_to :plan_post_aspect, :class_name => 'Plan::PostAspect', :foreign_key => :plan_post_aspect_id
  has_many :plan_post_action_resourceses, :class_name => 'Plan::PostActionResources'
end
