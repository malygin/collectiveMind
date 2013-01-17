class Estimate::TaskTriplet < ActiveRecord::Base
  attr_accessible :on, :on1, :on2, :on3, :op, :op1, :op2, :op3, :ozf, :ozf1, :ozf2, :ozf3, :ozs, :ozs1, :ozs2, :ozs3
  belongs_to :post
  belongs_to :task_triplet, :class_name => 'Plan::TaskTriplet'
end
