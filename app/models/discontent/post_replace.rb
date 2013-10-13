class Discontent::PostReplace < ActiveRecord::Base
  attr_accessible :post_id, :replace_id
  belongs_to :post
  belongs_to :replace_post, :class_name => "Discontent::Post", :foreign_key => :replace_id
end
