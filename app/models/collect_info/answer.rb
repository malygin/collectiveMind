class CollectInfo::Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  #  status = 0 if question is active, status = 1 unless
  scope :by_status, ->(status) { where(collect_info_answers: {status: status}) }
  scope :by_correct, -> { where(collect_info_answers: {correct: true}) }
  scope :by_uncorrect, -> { where(collect_info_answers: {correct: ['f', nil]}) }

  validates :content, :question_id, :correct, presence: true
end
