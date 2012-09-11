class TestQuestionAttempt < ActiveRecord::Base
  attr_accessible :answer, :test_attempt, :test_question
  belongs_to :test_attempt
  belongs_to :test_question
  

end
