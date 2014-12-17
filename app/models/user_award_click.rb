class UserAwardClick < ActiveRecord::Base
  belongs_to :user
  belongs_to :project, class_name: 'Core::Project'
end
