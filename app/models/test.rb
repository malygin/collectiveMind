class Test < ActiveRecord::Base
  attr_accessible :description, :name, :preview
  belongs_to :project
  has_many :test_questions
  has_many :test_attempts

  def ordering_questions
  	self.test_questions.find(:all, :order => "order_question ASC")
  end
  def avialable?
  	if test_attempts.empty?
  		return true
  	end
  	test_attempts.each do |a|
  		if a.user == curent_user
  			return false
  		end
  	end
  	true
  end

end
