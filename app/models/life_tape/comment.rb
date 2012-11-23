class LifeTape::Comment < ActiveRecord::Base
  attr_accessible :content, :user
  belongs_to :user
  belongs_to :post
  default_scope :order => 'life_tape_comments.created_at ASC'
  has_many :comment_voitings
  has_many :users, :through => :comment_voitings


end
