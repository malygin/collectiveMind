class Discontent::CommentNote < ActiveRecord::Base
  # attr_accessible :content, :post_id, :type, :user_id
  # include BaseComment
  attr_accessible :content, :post_id, :type_field, :user_id
  belongs_to :user, :class_name => "User"
  belongs_to :post, :class_name => "Discontent::Post"
end
