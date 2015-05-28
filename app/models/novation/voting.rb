class Novation::Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :novation_post, class_name: 'Novation::Post'

  validates :user_id, :novation_post_id, presence: true
end
