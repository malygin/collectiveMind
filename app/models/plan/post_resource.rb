class Plan::PostResource < ActiveRecord::Base
  attr_accessible :desc, :name
  belongs_to :plan_post_aspect, :class_name => 'Plan::PostAspect'
  belongs_to :concept_resource, :class_name => 'Concept::Resource'
  scope :by_post, ->(p){where(:post_id => p)}
end
