class Plan::PostStage < ActiveRecord::Base
  attr_accessible :date_begin, :date_end, :desc, :name, :post, :status
  belongs_to :post, :class_name => 'Plan::Post'
  has_many :plan_post_aspects, :class_name => 'Plan::PostAspect', :foreign_key => :post_stage_id

end
