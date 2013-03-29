class LifeTape::Voiting < ActiveRecord::Base
    attr_accessible :discontent_aspect_id, :user_id, :user
    belongs_to :user
	belongs_to :discontent_aspect
end
