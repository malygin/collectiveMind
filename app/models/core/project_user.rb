class Core::ProjectUser < ActiveRecord::Base
  attr_accessible :project_id, :status, :user_id
  belongs_to :core_project, class_name: 'Core::Project', foreign_key: 'project_id'
  belongs_to :user
end
