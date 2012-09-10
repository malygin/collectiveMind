class TestQuestion < ActiveRecord::Base
  attr_accessible :name, :type_question
  belongs_to :test
  has_many :test_answers
end
