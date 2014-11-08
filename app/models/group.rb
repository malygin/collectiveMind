class Group < ActiveRecord::Base
  #@todo remove
  attr_accessible :name, :description, :project_id
  belongs_to :project
  has_many :group_users
  has_many :users, through: :group_users

  scope :by_project, -> (project) { where project_id: project.id }
end
