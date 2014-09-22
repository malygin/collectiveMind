class UserCheck < ActiveRecord::Base
  attr_accessible :check_field, :status, :user, :project_id, :value
  belongs_to :user
end
