class LifeTape::Post < ActiveRecord::Base
  attr_accessible :important, :aspect
  include BasePost
  has_many :childs, :class_name => 'LifeTape::Post', :foreign_key => 'post_id'
  belongs_to :post, :class_name => 'LifeTape::Post'

  has_many :life_tape_post_discussions, :class_name => 'LifeTape::PostDiscussion'
  has_many :post_discussion_users, :through => :life_tape_post_discussions, :source => :user, :class_name => 'User'
  scope :by_discussions, ->(posts) { where("life_tape_posts.id NOT IN (#{posts.join(", ")})") unless posts.empty? }

  #belongs_to :aspect, :class_name =>'Discontent::Aspect', :foreign_key =>  'aspect_id'
  has_and_belongs_to_many :discontent_aspects, :class_name => 'Discontent::Aspect',  join_table: 'discontent_aspects_life_tape_posts', foreign_key: 'life_tape_post_id', association_foreign_key: 'discontent_aspect_id'


end
