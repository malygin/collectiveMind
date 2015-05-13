class UserCheck < ActiveRecord::Base
  belongs_to :user
  belongs_to :project, class_name: 'Core::Project'
  scope :check_field, ->(p, c) { where(project_id: p.id, status: 't', check_field: c) }
  validates :check_field, :user_id, :project_id, presence: true
end
