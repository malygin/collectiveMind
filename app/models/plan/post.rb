class Plan::Post < ActiveRecord::Base
   include BasePost
  attr_accessible :first_step, :goal, :other_steps

  has_many :task_triplets, :order => 'position'
  has_many :estimates, :class_name => 'Estimate::Post'
  
end
