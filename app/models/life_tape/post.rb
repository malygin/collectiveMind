class LifeTape::Post < ActiveRecord::Base

  include BasePost
  has_many :childs, :class_name => "LifeTape::Post", :foreign_key => "post_id"
  belongs_to :post, :class_name => "LifeTape::Post"
end
