class GroupTask < ActiveRecord::Base
  belongs_to :group
  has_many :group_task_users, class_name: 'GroupTaskUser'
  has_many :users, through: :group_task_users

  STATUSES = {
      10 => 'Создана',
      20 => 'Выполняется',
      30 => 'Требует обсуждения',
      40 => 'Выполнена'
  }

  validates :name, :description, presence: true
  validates :status, inclusion: {in: STATUSES.keys}
end
