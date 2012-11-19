class LifeTape::CommentVoiting < ActiveRecord::Base
  attr_accessible :comment, :user
    belongs_to :user
	belongs_to :comment
end
