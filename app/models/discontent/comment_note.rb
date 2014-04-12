class Discontent::CommentNote < ActiveRecord::Base
  attr_accessible :content, :post_id, :user_id, :type_field, :status
  belongs_to :user, :class_name => "User"
  belongs_to :post, :class_name => "Discontent::Post"

  scope :by_type,   ->(type){where(type_field: type)}
end
