class LifeTape::Category < ActiveRecord::Base
  attr_accessible :long_desc, :name, :short_desc
  has_many :posts
end
