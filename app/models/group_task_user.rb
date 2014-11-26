class GroupTaskUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group_task

  attr_accessible :user_id, :group_task_id
end
