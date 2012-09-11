class TestAnswer < ActiveRecord::Base
  attr_accessible :name, :type_answer
  attr_accessor :user_answer
  belongs_to :test_question

end
