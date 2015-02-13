class News < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :title, :project_id, :user_id, presence: true

  scope :for_last_day, -> { where(created_at: 1.days.ago..Time.now) }
end
