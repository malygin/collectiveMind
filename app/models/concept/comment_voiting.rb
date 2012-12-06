class Concept::CommentVoiting < ActiveRecord::Base
  attr_accessible :comment, :user
    belongs_to :user
	belongs_to :commentend
end
