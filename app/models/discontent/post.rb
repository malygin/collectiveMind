class Discontent::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :when, :where, :aspect_id, :replace_id, :aspect
  belongs_to :aspect
  has_many :childs, :class_name => "Discontent::Post", :foreign_key => "replace_id"
  belongs_to :post, :class_name => "Discontent::Post", :foreign_key => "replace_id"
end
