class Core::ProjectUser < ActiveRecord::Base
  belongs_to :core_project, class_name: 'Core::Project', foreign_key: 'project_id'
  belongs_to :user
  scope :by_project, ->(pr) { where(project_id: pr) }
end
