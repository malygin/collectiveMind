class Plan::PostResource < ActiveRecord::Base
  attr_accessible :desc, :name, :type_res, :project_id
  belongs_to :plan_post_aspect, :class_name => 'Plan::PostAspect'
  belongs_to :concept_resource, :class_name => 'Concept::Resource'
  belongs_to :project, :class_name => "Core::Project"
  scope :by_post, ->(p){ where(:post_id => p) }
  scope :by_type, ->(type){ where(:type_res => type) }
  scope :by_project, ->(p){ where(project_id: p) }
end
