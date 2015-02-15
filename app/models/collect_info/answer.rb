class CollectInfo::Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  scope :by_status, ->(status) { where(collect_info_answers: {status: status}) }
  scope :by_correct, ->(correct) { where(collect_info_answers: {correct: correct}) }

  validates :content, :question_id, :correct, presence: true
end