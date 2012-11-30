class UserAward < ActiveRecord::Base
  attr_accessible :award, :user
  belongs_to :award
  belongs_to :user
end
