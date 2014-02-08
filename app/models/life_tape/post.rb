class LifeTape::Post < ActiveRecord::Base
  attr_accessible :important
  include BasePost
  has_many :childs, :class_name => 'LifeTape::Post', :foreign_key => 'post_id'
  belongs_to :post, :class_name => 'LifeTape::Post'
  #belongs_to :aspect, :class_name =>'Discontent::Aspect', :foreign_key =>  'aspect_id'
  has_and_belongs_to_many :discontent_aspects, :class_name => 'Discontent::Aspect', join_table: 'discontent_aspects_life_tape_posts', foreign_key: 'life_tape_post_id', association_foreign_key: 'discontent_aspect_id'
  scope :popular_posts, joins(:comments).group(:id).select('"life_tape_posts".*, count(life_tape_comments.id) as count_comment ').reorder('count_comment ASC')


end
