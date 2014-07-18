class Concept::PostResource < ActiveRecord::Base
  attr_accessible :desc, :name, :project_id, :type_res
  belongs_to :concept_post, :class_name => 'Concept::Post', :foreign_key => :post_id
  belongs_to :concept_resource, :class_name => 'Concept::Resource'
  belongs_to :project, :class_name => "Core::Project"
  scope :by_project, ->(p){ where(project_id: p) }
  scope :by_type, ->(type){ where(:type_res => type) }
end
