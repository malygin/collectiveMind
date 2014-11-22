class Group < ActiveRecord::Base
  #@todo remove
  attr_accessible :name, :description, :project_id
  belongs_to :project, class_name: 'Core::Project'
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :chat_messages, class_name: 'GroupChatMessage'

  scope :by_project, -> (project) { where project_id: project.id }
  scope :owner, -> { joins(:group_users).where(owner: true) }

  validates :name, :project_id, presence: true
end
