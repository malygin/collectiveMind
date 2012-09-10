class TestAnswer < ActiveRecord::Base
  attr_accessible :name, :type_answer
  belongs_to :test_question

end
