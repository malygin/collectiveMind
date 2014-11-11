class Group < ActiveRecord::Base
  #@todo remove
  attr_accessible :name, :description, :project_id
  belongs_to :project, class_name: 'Core::Project'
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users

  scope :by_project, -> (project) { where project_id: project.id }

  validates :name, :project_id, presence: true
end
