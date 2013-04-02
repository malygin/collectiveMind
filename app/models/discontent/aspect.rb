class Discontent::Aspect < ActiveRecord::Base
  include BasePost
  attr_accessible :position 
  has_many :posts
  
  has_many :voted_users, :through => :final_voitings, :source => :user
  has_many :final_voitings,:foreign_key => 'discontent_aspect_id', :class_name => "LifeTape::Voiting"
end
