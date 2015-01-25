class Core::UserAwardClick < ActiveRecord::Base
  belongs_to :user
  belongs_to :project, class_name: 'Core::Project'

  validates  :user_id, :project_id, presence: true
end
