class GroupUser < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  scope :by_group, -> (group) { find_by_group_id group.id }

  validates :user_id, :group_id, presence: true
end
