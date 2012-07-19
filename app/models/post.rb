class Post < ActiveRecord::Base
  attr_accessible :text, :title

  validates :title, :presence => true, :length => { :minimum =>5 }
  has_many :comments
end
