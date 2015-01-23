class Poll::Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  scope :by_status, ->(status) { where(answers: {status: status}) }
  scope :by_style, ->(style) { where(answers: {style: style}) }
end