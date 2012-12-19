class Concept::Post < ActiveRecord::Base
 # 0 - new,  1 - archiv, 2 - to expert, 3 - accepted 
  attr_accessible :goal, :life_tape_post_id, :number_views, :reality, :user, :status
  belongs_to :user
  belongs_to :life_tape_post,  :class_name => "LifeTape::Post"
  has_many :comments
  has_many :task_supply_pairs
  has_many :post_notes

  has_many :post_voitings
  has_many :users, :through => :post_voitings
  default_scope :order => 'concept_posts.created_at DESC'

end
