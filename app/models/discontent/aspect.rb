class Discontent::Aspect < ActiveRecord::Base
  include BasePost
  attr_accessible :position, :short_desc
   has_many :posts
   has_many :positive_posts, :class_name => 'Discontent::Post',
           :conditions => ['discontent_posts.style = ? and discontent_posts.status = ?',0,2]   
   has_many :negative_posts, :class_name => 'Discontent::Post',
           :conditions => ['discontent_posts.style = ? and discontent_posts.status = ?',1,2]
  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings,:foreign_key => 'discontent_aspect_id', :class_name => "LifeTape::Voiting"
 
end
