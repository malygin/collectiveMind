class Concept::Comments < ActiveRecord::Base
  attr_accessible :content, :post, :useful, :user
  belongs_to :user
  belongs_to :post

end
