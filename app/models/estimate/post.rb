class Estimate::Post < ActiveRecord::Base
  include BasePost

  # 0 - new post, 1 - accepted post, 2 - declined post
  attr_accessible  :imp, :nepr, :nepr1, :nepr2, :nepr3, :nepr4, :onpsh, :onpsh1, :onpsh2, :onpsh3, :oppsh, :oppsh1, :oppsh2, :oppsh3, :ozpshf, :ozpshf1, :ozpshf2, :ozpshf3, :ozpshs, :ozpshs1, :ozpshs2, :ozpshs3
  attr_accessor :first_c, :second_c, :third_c

  belongs_to :post, :class_name => 'Plan::Post'
  has_many :post_aspects
  has_many :plan_post_aspects, :class_name => 'Plan::PostAspect'
  #scope :by_firts_stage , lambda do |stage|
  #  joins(:plan_post_aspects).where('plan_post_aspects.first_stage = ?', stage)
  #end
  has_many :post_aspects_first, :foreign_key => 'post_id', :class_name => 'Estimate::PostAspect',
           :conditions => [' join plan_post_aspect on (estimate_post_aspect.plan_post_aspect = plan_post_aspect.id)  plan_post_aspect.first_stage = ?',1]
  has_many :post_aspects_other, :foreign_key => 'post_id', :class_name => 'Estimate::PostAspect',
           :conditions =>  {:first_stage => 0}

  


  def score
  	oppsh_i=(3*oppsh1+2*oppsh2+1*oppsh3)/(oppsh1+oppsh2+oppsh3).to_f
  	onpsh_i=(3*onpsh1+2*onpsh2+1*onpsh3)/(onpsh1+onpsh2+onpsh3).to_f
  	ozpshf_i=(3*ozpshf1+2*ozpshf2+1*ozpshf3)/(ozpshf1+ozpshf2+ozpshf3).to_f
  	ozpshs_i=(3*ozpshs1+2*ozpshs2+1*ozpshs3)/(ozpshs1+ozpshs2+ozpshs3).to_f
  	@second_c=(oppsh_i*onpsh_i)/(ozpshf_i*ozpshs_i).to_f
    @second_c = (100*@second_c).round/100.0
  	sum_tr=0.0
  	task_triplets.each do |tr|
	  	op_i=(3*tr.op1+2*tr.op2+1*tr.op3)/(tr.op1+tr.op2+tr.op3).to_f
	  	on_i=(3*tr.on1+2*tr.on2+1*tr.on3)/(tr.on1+tr.on2+tr.on3).to_f
	  	ozf_i=(3*tr.ozf1+2*tr.ozf2+1*tr.ozf3)/(tr.ozf1+tr.ozf2+tr.ozf3).to_f
	  	ozs_i=(3*tr.ozs1+2*tr.ozs2+1*tr.ozs3)/(tr.ozs1+tr.ozs2+tr.ozs3).to_f
	  	sum_tr = sum_tr +  2*(op_i*on_i)/(ozf_i*ozs_i).to_f
	  	#puts "__________", sum_tr, op_i, on_i, ozf_i, ozs_i

  	end
  	#puts "__________", sum_tr
  	@first_c = (sum_tr*100).round / 100.0
  	@third_c = ((4*nepr1 + 3*nepr2 + 2*nepr3 + 1*nepr4)/(nepr1+nepr2+nepr3+nepr4).to_f*100).round/100.0
  	((@second_c+@first_c-@third_c)*100).round / 100.0

  	# oppsh_i=(1*oppsh1+2*oppsh2+3*oppsh3)/(oppsh1+oppsh2+oppsh3)

  end
end
