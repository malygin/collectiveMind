class Estimate::TaskTriplet < ActiveRecord::Base
  attr_accessible :on, :on1, :on2, :on3, :op, :op1, :op2, :op3, :ozf, :ozf1, :ozf2, :ozf3, :ozs, :ozs1, :ozs2, :ozs3
  belongs_to :post
  belongs_to :task_triplet, :class_name => 'Plan::TaskTriplet'
  def score
  	op_i=(3*op1+2*op2+1*op3)/(op1+op2+op3).to_f
	on_i=(3*on1+2*on2+1*on3)/(on1+on2+on3).to_f
	ozf_i=(3*ozf1+2*ozf2+1*ozf3)/(ozf1+ozf2+ozf3).to_f
	ozs_i=(3*ozs1+2*ozs2+1*ozs3)/(ozs1+ozs2+ozs3).to_f
	r = 2* (op_i*on_i)/(ozf_i*ozs_i).to_f
	(r*100).round/100.0
	#r
  end
end
