class UserAward < ActiveRecord::Base
  belongs_to :award
  belongs_to :project, class_name: 'Core::Project'
  belongs_to :user
end
