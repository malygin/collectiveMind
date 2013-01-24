class Estimate::Comment < ActiveRecord::Base
  attr_accessible :content, :user, :post
  belongs_to :user
  belongs_to :post
  default_scope :order => 'estimate_comments.created_at ASC'
  
  has_many :comment_voitings
  has_many :users, :through => :comment_voitings
end