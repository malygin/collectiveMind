class LifeTape::Comment < ActiveRecord::Base
  attr_accessible :content, :user
  belongs_to :user
  belongs_to :post
  default_scope :order => 'life_tape_comments.created_at DESC'

end
