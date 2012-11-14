class LifeTape::Post < ActiveRecord::Base
  attr_accessible :content, :category_id
  
  belongs_to :category
  belongs_to :user

  has_many :childs, :class_name => "LifeTape::Post", :foreign_key => "post_id"
  belongs_to :ancesor, :class_name => "LifeTape::Post", :foreign_key => "post_id"
  has_many :comments
  default_scope :order => 'life_tape_posts.created_at DESC'

end
