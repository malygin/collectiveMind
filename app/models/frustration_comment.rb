class FrustrationComment < ActiveRecord::Base
  attr_accessible :user_id, :content, :negative

  belongs_to :user
  belongs_to :frustration

  
end
