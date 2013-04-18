class Plan::PostVoting < ActiveRecord::Base
  attr_accessible :against, :post, :user

    belongs_to :user
	belongs_to :post
end
