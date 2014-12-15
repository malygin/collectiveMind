class UserAward < ActiveRecord::Base
  belongs_to :award
  belongs_to :project, class_name: 'Core::Project'
  #scope :awards_for_project, lambda  {|project| where(project_id: project) }
  belongs_to :user
end
