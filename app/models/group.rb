class Group < ActiveRecord::Base
  #@todo remove
  attr_accessible :name, :description, :project_id
  belongs_to :project, class_name: 'Core::Project'
  has_many :all_group_users, class_name: 'GroupUser', dependent: :destroy
  has_many :group_users, -> { where invite_accepted: true }
  has_many :users, through: :group_users
  has_many :user_plan_posts, through: :users, source: :plan_posts
  has_many :chat_messages, class_name: 'GroupChatMessage'
  has_many :tasks, class_name: 'GroupTask'

  scope :by_project, -> (project) { where project_id: project.id }

  validates :name, :project_id, presence: true

  def user_projects
    user_plan_posts.by_project(project_id)
  end

  def owner
    group_users.find_by(owner: true).try(:user)
  end

  def moderators
    users.where(type_user: User::TYPES_USER[:admin])
  end

  def count_new_messages_for(group_user)
    chat_messages.where('created_at > ?', group_user.last_seen_chat_at).count
  end
end
