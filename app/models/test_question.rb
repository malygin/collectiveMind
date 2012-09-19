class TestQuestion < ActiveRecord::Base
  attr_accessible :name, :type_question, :order_question
  attr_accessor :result
  belongs_to :test
  has_many :test_answers
  has_many :test_question_attempts
end
