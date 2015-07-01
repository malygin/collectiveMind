class Aspect::Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :aspect, class_name: 'Aspect::Post'

  scope :by_status, ->(status) { where(status: status) }

  validates :user_id, :aspect_id, presence: true
end
