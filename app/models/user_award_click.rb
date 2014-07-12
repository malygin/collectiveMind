class UserAwardClick < ActiveRecord::Base
  attr_accessible :clicks, :project_id, :user_id
  belongs_to :user
  belongs_to :project, :class_name => "Core::Project"
end
