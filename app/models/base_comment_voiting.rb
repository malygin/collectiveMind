module BaseCommentVoiting extend ActiveSupport::Concern
  	included do
	  	attr_accessible :comment, :user
	    belongs_to :user
		belongs_to :comment
	end
end
