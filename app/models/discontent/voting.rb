class Discontent::Voting < ActiveRecord::Base
  attr_accessible :discontent_post, :user, :against
  belongs_to :user
  belongs_to :discontent_post

  scope :by_positive, -> { where(against: 't') }
  scope :by_negative, -> { where(against: 'f') }
  scope :not_admins, -> { joins(:user).where.not(users: {type_user: User::TYPES_USER[:admin]}) }
  scope :uniq_user, -> { select('distinct user_id') }

  scope :by_posts_vote, ->(posts) { where("discontent_votings.discontent_post_id IN (#{posts})") unless posts.empty? }
end
