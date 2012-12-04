class FrustrationEssay < ActiveRecord::Base
  attr_accessible :content, :user
  belongs_to :user
end
