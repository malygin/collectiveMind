class Discontent::Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :discontent_post, class_name: 'Discontent::Post'

  validates :user_id, :discontent_post_id, presence: true

  scope :by_positive, -> { where(against: 't') }
  scope :by_negative, -> { where(against: 'f') }
  scope :not_admins, -> { joins(:user).merge(User.not_admins) }
  scope :uniq_user, -> { select('distinct user_id') }
  scope :by_status, ->(status) { where(status: status) }
end
