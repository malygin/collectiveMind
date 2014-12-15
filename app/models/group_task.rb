class GroupTask < ActiveRecord::Base
  belongs_to :group
  has_many :group_task_users, class_name: 'GroupTaskUser'
  has_many :users, through: :group_task_users

  validates :name, :description, presence: true
end
