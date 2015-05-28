class Plan::Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan_post, class_name: 'Plan::Post'

  validates :user_id, :plan_post_id, presence: true

  scope :uniq_user, -> { select('distinct user_id') }
  scope :by_status, ->(s) { where(status: s) }
  scope :by_type, ->(type) { where(type_vote: type) }
  scope :by_post, ->(p) { where(plan_post_id: p.id) }
end
