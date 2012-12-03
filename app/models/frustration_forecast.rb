class FrustrationForecast < ActiveRecord::Base
  attr_accessible :frustration, :order, :user
  belongs_to :user
  belongs_to :frustration
end
