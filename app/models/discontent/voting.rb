class Discontent::Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :discontent_post

  scope :by_positive, -> { where(against: 't') }
  scope :by_negative, -> { where(against: 'f') }
  scope :not_admins, -> { joins(:user).where("users.type_user NOT IN (?) or users.type_user IS NULL", User::TYPES_USER[:admin]) }
  scope :uniq_user, -> { select('distinct user_id') }

  scope :by_posts_vote, ->(posts) { where("discontent_votings.discontent_post_id IN (#{posts})") unless posts.empty? }
end
