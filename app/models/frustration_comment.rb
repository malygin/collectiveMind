class FrustrationComment < ActiveRecord::Base
  attr_accessible :user_id, :content

  belongs_to :user
  belongs_to :frustration

end
