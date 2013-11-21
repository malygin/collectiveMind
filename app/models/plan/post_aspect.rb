class Plan::PostAspect  < ActiveRecord::Base
  attr_accessible :discontent_aspect_id, :plan_post_id, :content, :control,
                  :name, :negative, :positive, :reality, :problems, :first_stage

  belongs_to :concept_post_aspect, :class_name => 'Concept::PostAspect', :foreign_key => :concept_post_aspect_id
  belongs_to :plan_post, :class_name => 'Plan::Post', :foreign_key => :plan_post_id
  belongs_to :discontent, :class_name => 'Discontent::Post', :foreign_key => :discontent_aspect_id
  has_many :plan_post_first_conds, :class_name => 'Plan::PostFirstCond'
end
