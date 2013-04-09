class Discontent::Voting < ActiveRecord::Base
    attr_accessible :discontent_post, :user
    belongs_to :user
  	belongs_to :discontent_post
end
