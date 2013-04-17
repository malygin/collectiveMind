class Discontent::Aspect < ActiveRecord::Base
  include BasePost
  attr_accessible :position, :short_desc
  has_many :posts
  
  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings,:foreign_key => 'discontent_aspect_id', :class_name => "LifeTape::Voiting"
end
