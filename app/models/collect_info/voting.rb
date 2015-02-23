class CollectInfo::Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :aspect, class_name: 'Core::Aspect'

  validates :user_id, :aspect_id, presence: true
end
