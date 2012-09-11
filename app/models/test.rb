class Test < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :project
  has_many :test_questions
  has_many :test_attempts
end
