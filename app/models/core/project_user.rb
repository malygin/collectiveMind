class Core::ProjectUser < ActiveRecord::Base
  attr_accessible :project_id, :status, :user_id, :ready_to_concept, :ready_to_plan
  belongs_to :core_project, class_name: 'Core::Project', foreign_key: 'project_id'
  belongs_to :user
  scope :by_project, ->(pr) { where(project_id: pr) }
end
