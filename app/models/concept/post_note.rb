class Concept::PostNote < ActiveRecord::Base
  attr_accessible :content
  belongs_to :post
  belongs_to :user

  
end
