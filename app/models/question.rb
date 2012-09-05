class Question < ActiveRecord::Base
  attr_accessible :raiting, :text
  
  belongs_to :user
  has_many :answers


end
