class LifeTape::Post < ActiveRecord::Base
  attr_accessible :content, :category_id, :post_id, :number_views
  
  belongs_to :category
  belongs_to :user

  has_many :childs, :class_name => "LifeTape::Post", :foreign_key => "post_id"
  belongs_to :post, :class_name => "LifeTape::Post"
  # has_many :post_inspirings
  # has_many :inspireds, :through => :post_inspirings
  # # has_many :post_inspired, :class_name => "LifeTape::PostInspiring", :foreign_key => "inspired_post_id"
  # # has_many :inspired_by, :through => :post_inspired, :source => :use
  has_many :post_voitings
  has_many :users, :through => :post_voitings

  has_many :comments
  default_scope :order => 'life_tape_posts.created_at DESC'

end
