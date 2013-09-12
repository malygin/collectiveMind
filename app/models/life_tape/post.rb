class LifeTape::Post < ActiveRecord::Base
  attr_accessible :important
  include BasePost
  has_many :childs, :class_name => 'LifeTape::Post', :foreign_key => 'post_id'
  belongs_to :post, :class_name => 'LifeTape::Post'
  belongs_to :aspect, :class_name =>'Discontent::Aspect', :foreign_key =>  'aspect_id'

end
