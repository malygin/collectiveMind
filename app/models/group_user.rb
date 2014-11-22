class GroupUser < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  #@todo remove
  attr_accessible :group_id, :user_id, :owner

  validates :user_id, :group_id, presence: true
end
