class GroupUser < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  #@todo remove
  attr_accessible :group_id, :user_id, :owner, :invite_accepted, :last_seen_chat_at

  scope :by_group, -> (group) { find_by_group_id group.id }

  validates :user_id, :group_id, presence: true
end
