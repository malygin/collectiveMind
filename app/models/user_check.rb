class UserCheck < ActiveRecord::Base
  attr_accessible :check_field, :status, :user,:project_id
  belongs_to :user
end
