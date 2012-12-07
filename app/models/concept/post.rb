class Concept::Post < ActiveRecord::Base
  attr_accessible :goal, :life_tape_post, :number_views, :reality, :user
  belongs_to :user
  belongs_to :life_tape_post
  has_many :comments
  has_many :task_supply_pairs
end
