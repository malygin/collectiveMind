class CollectInfo::Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  scope :by_status, ->(status) { where(collect_info_answers: {status: status}) }
  scope :by_correct, -> { where(collect_info_answers: {correct: true}) }
  scope :by_uncorrect, -> { where(collect_info_answers: {correct: ['f', nil]}) }

  validates :content, :question_id, :correct, presence: true
end
