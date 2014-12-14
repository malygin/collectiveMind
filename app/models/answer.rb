class Answer < ActiveRecord::Base
  attr_accessible :style, :user, :question, :status, :content
  belongs_to :question
  belongs_to :user
  scope :by_status, ->(status) { where(answers: {status: status}) }
end