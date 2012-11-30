class Award < ActiveRecord::Base
  attr_accessible :desc, :name, :url
  has_many :user_awards
  has_many :users, :through => :user_awards

end
