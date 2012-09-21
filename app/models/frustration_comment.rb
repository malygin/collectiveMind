class FrustrationComment < ActiveRecord::Base
  attr_accessible :user_id,:trash, :content, :negative, :frustration_comment
  has_many :replies, :class_name => "FrustrationComment", :foreign_key => "frustration_comment_id"

  belongs_to :frustration_comment
  belongs_to :user
  belongs_to :frustration

  
end
