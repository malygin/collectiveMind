class Question < ActiveRecord::Base
  attr_accessible :raiting, :text
  
  belongs_to :user
  #voiting system
  has_and_belongs_to_many :users

  has_many :answers

  def answers_order
  	self.answers.find(:all, :order => "raiting DESC")
  end




end
