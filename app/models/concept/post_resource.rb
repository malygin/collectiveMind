class Concept::PostResource < ActiveRecord::Base
  belongs_to :concept_post, class_name: 'Concept::Post', foreign_key: :post_id
  belongs_to :concept_resource, class_name: 'Concept::Resource'
  belongs_to :project, class_name: 'Core::Project'
  belongs_to :concept_post_resource, class_name: 'Concept::PostResource', foreign_key: :concept_post_resource_id

  has_many :concept_post_resources, class_name: 'Concept::PostResource', foreign_key: :concept_post_resource_id

  scope :by_project, ->(p) { where(project_id: p) }
  scope :by_type, ->(type) { where(type_res: type) }
end
