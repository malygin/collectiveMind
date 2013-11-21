class Plan::PostFirstCond < ActiveRecord::Base
  attr_accessible :plan_post_id, :post_aspect_id, :content, :control,
                  :name, :negative, :positive, :reality, :problems, :problems_with_resources


  belongs_to :plan_post, :class_name => 'Plan::Post', :foreign_key => :plan_post_id
  belongs_to :post_aspect, :class_name => 'Plan::PostAspect', :foreign_key => :post_aspect_id

end
