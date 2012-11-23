class Question < ActiveRecord::Base
  attr_accessible :raiting, :text
  
  belongs_to :user
  #voiting system
  has_and_belongs_to_many :users

  has_many :answers
  default_scope :order => 'questions.created_at DESC'

  def answers_order
  	self.answers.find(:all, :order => "created_at ASC")
  end




end
