class Aspect::Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  #  status = 0 if question is active, status = 1 unless
  scope :by_status, ->(status) { where(aspect_answers: { status: status }) }
  scope :by_correct, -> { where(aspect_answers: { correct: true }) }
  scope :by_wrong, -> { where(aspect_answers: { correct: ['f', nil] }) }

  validates :content, :question_id, presence: true
  default_scope { order :id }
end
