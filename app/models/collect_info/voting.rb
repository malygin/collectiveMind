class CollectInfo::Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :aspect
end
