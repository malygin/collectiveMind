class Test < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :project
  has_many :test_questions
  has_many :test_attempts

  def ordering_questions
  	self.test_questions.find(:all, :order => "order_question ASC")
  end

end
