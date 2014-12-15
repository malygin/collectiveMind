class GroupTaskUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group_task
end
