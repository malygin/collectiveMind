 class Concept::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :goal, :reality
  belongs_to :life_tape_post,  :class_name => "LifeTape::Post"
  has_many :task_supply_pairs


end
