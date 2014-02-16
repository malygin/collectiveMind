class Discontent::Aspect < ActiveRecord::Base
  include BasePost
  attr_accessible :position, :short_desc, :user_add
   has_many :posts
   has_many :positive_posts, :class_name => 'Discontent::Post',
           :conditions => ['discontent_posts.style = ? and (discontent_posts.status = ? or discontent_posts.status = ? )',0,2,4]
   has_many :negative_posts, :class_name => 'Discontent::Post',
           :conditions => ['discontent_posts.style = ? and (discontent_posts.status = ? or discontent_posts.status = ?)',1,2,4]
   has_many :accepted_posts, :class_name => 'Discontent::Post',
           :conditions => ['discontent_posts.status = ?',4]

  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings,:foreign_key => 'discontent_aspect_id', :class_name => "LifeTape::Voiting"

  has_and_belongs_to_many :life_tape_posts, :class_name => 'LifeTape::Post', join_table: 'discontent_aspects_life_tape_posts', foreign_key: 'discontent_aspect_id', association_foreign_key: 'life_tape_post_id'

  def voted(user)
    self.voted_users.where(:id => user)
  end
end
