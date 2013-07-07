 class Concept::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :goal, :reality
  belongs_to :life_tape_post,  :class_name => "LifeTape::Post"
  has_many :task_supply_pairs
  has_many :post_aspects, :foreign_key => 'concept_post_id', :class_name => "Concept::PostAspect"

  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings,:foreign_key => 'concept_post_id', :class_name => "Concept::Voting"


end
