class TestAttempt < ActiveRecord::Base
  attr_accessible :test, :user
  belongs_to :test
  belongs_to :user
  has_many :test_question_attempts
end
