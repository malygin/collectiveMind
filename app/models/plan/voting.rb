class Plan::Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan_post, class_name: 'Plan::Post'
  scope :uniq_user, -> { select('distinct user_id') }
end

