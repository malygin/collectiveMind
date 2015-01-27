class UserCheck < ActiveRecord::Base
  belongs_to :user

  validates :check_field, :user_id, :project_id, presence: true
end
