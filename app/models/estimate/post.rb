class Estimate::Post < ActiveRecord::Base
  include BasePost

  # 0 - new post, 1 - accepted post, 2 - declined post
  attr_accessible  :imp, :nepr, :nepr1, :nepr2, :nepr3, :nepr4,
                   :nep, :nep1, :nep2, :nep3, :nep4, :all_grade,
                   :onpsh, :onpsh1, :onpsh2, :onpsh3, :oppsh, :oppsh1, :oppsh2, :oppsh3, :ozpshf, :ozpshf1, :ozpshf2, :ozpshf3, :ozpshs, :ozpshs1, :ozpshs2, :ozpshs3
  attr_accessor :first_c, :second_c, :third_c

  belongs_to :post, :class_name => 'Plan::Post'
  has_many :post_aspects
  has_many :plan_post_aspects, :class_name => 'Plan::PostAspect'
  #scope :by_firts_stage , lambda do |stage|
  #  joins(:plan_post_aspects).where('plan_post_aspects.first_stage = ?', stage)
  #end

  has_many :post_aspects_other, :foreign_key => 'post_id', :class_name => 'Estimate::PostAspect',
           :conditions =>  {:first_stage => false}
  has_many :post_aspects_first, :foreign_key => 'post_id', :class_name => 'Estimate::PostAspect',
           :conditions =>  {:first_stage => true}
  has_many :post_aspects_all, :foreign_key => 'post_id', :class_name => 'Estimate::PostAspect'

  


  def score

  	sum_tr=0.0
    post_aspects.others.each do |tr|
      op_i=(tr.op1+tr.op2+tr.op3+tr.op4) ==0 ? 0 :  33.33 * (3*tr.op1+2*tr.op2+1*tr.op3)/(tr.op1+tr.op2+tr.op3+tr.op4).to_f
      on_i=(tr.on1+tr.on2+tr.on3+tr.on4) ==0 ? 0 :  33.33 * (3*tr.on1+2*tr.on2+1*tr.on3)/(tr.on1+tr.on2+tr.on3+tr.on4).to_f
      ozf_i=(tr.ozf1+tr.ozf2+tr.ozf3+tr.ozf4) ==0 ? 0 : 33.33 * (3*tr.ozf1+2*tr.ozf2+1*tr.ozf3)/(tr.ozf1+tr.ozf2+tr.ozf3+tr.ozf4).to_f
      ozs_i=(tr.ozs1+tr.ozs2+tr.ozs3+tr.ozs4) ==0 ? 0 : 33.33 * (3*tr.ozs1+2*tr.ozs2+1*tr.ozs3)/(tr.ozs1+tr.ozs2+tr.ozs3+tr.ozs4).to_f
      # op_i=(tr.op1+tr.op2+tr.op3+tr.op4) ==0 ? 0 :  ((95/100.to_f)*tr.op1+(70/100.to_f)*tr.op2+(30/100.to_f)*tr.op3)/(tr.op1+tr.op2+tr.op3+tr.op4).to_f
      # on_i=(tr.on1+tr.on2+tr.on3+tr.on4) ==0 ? 0 :   ((95/100.to_f)*tr.on1+(70/100.to_f)*tr.on2+(30/100.to_f)*tr.on3)/(tr.on1+tr.on2+tr.on3+tr.on4).to_f
      # ozf_i=(tr.ozf1+tr.ozf2+tr.ozf3+tr.ozf4) ==0 ? 0 : ((95/100.to_f)*tr.ozf1+(70/100.to_f)*tr.ozf2+(30/100.to_f)*tr.ozf3)/(tr.ozf1+tr.ozf2+tr.ozf3+tr.ozf4).to_f
      # ozs_i=(tr.ozs1+tr.ozs2+tr.ozs3+tr.ozs4) ==0 ? 0 :  ((95/100.to_f)*tr.ozs1+(70/100.to_f)*tr.ozs2+(30/100.to_f)*tr.ozs3)/(tr.ozs1+tr.ozs2+tr.ozs3+tr.ozs4).to_f
      sum_tr = sum_tr + ( (ozf_i*ozs_i) ==0 ? 0 : (op_i*on_i)/(ozf_i*ozs_i)).to_f
    end
  	#puts "__________", sum_tr
  	@first_c = sum_tr
    sum_tr=0.0
    post_aspects.firsts.each do |tr|
      op_i=(tr.op1+tr.op2+tr.op3+tr.op4) ==0 ? 0 :  33.33 * (3*tr.op1+2*tr.op2+1*tr.op3)/(tr.op1+tr.op2+tr.op3+tr.op4).to_f
      on_i=(tr.on1+tr.on2+tr.on3+tr.on4) ==0 ? 0 :  33.33 * (3*tr.on1+2*tr.on2+1*tr.on3)/(tr.on1+tr.on2+tr.on3+tr.on4).to_f
      ozf_i=(tr.ozf1+tr.ozf2+tr.ozf3+tr.ozf4) ==0 ? 0 : 33.33 * (3*tr.ozf1+2*tr.ozf2+1*tr.ozf3)/(tr.ozf1+tr.ozf2+tr.ozf3+tr.ozf4).to_f
      ozs_i=(tr.ozs1+tr.ozs2+tr.ozs3+tr.ozs4) ==0 ? 0 : 33.33 * (3*tr.ozs1+2*tr.ozs2+1*tr.ozs3)/(tr.ozs1+tr.ozs2+tr.ozs3+tr.ozs4).to_f
      # op_i=(tr.op1+tr.op2+tr.op3+tr.op4) ==0 ? 0 :  ((95/100.to_f)*tr.op1+(70/100.to_f)*tr.op2+(30/100.to_f)*tr.op3)/(tr.op1+tr.op2+tr.op3+tr.op4).to_f
      # on_i=(tr.on1+tr.on2+tr.on3+tr.on4) ==0 ? 0 :   ((95/100.to_f)*tr.on1+(70/100.to_f)*tr.on2+(30/100.to_f)*tr.on3)/(tr.on1+tr.on2+tr.on3+tr.on4).to_f
      # ozf_i=(tr.ozf1+tr.ozf2+tr.ozf3+tr.ozf4) ==0 ? 0 : ((95/100.to_f)*tr.ozf1+(70/100.to_f)*tr.ozf2+(30/100.to_f)*tr.ozf3)/(tr.ozf1+tr.ozf2+tr.ozf3+tr.ozf4).to_f
      # ozs_i=(tr.ozs1+tr.ozs2+tr.ozs3+tr.ozs4) ==0 ? 0 :  ((95/100.to_f)*tr.ozs1+(70/100.to_f)*tr.ozs2+(30/100.to_f)*tr.ozs3)/(tr.ozs1+tr.ozs2+tr.ozs3+tr.ozs4).to_f
      sum_tr = sum_tr + ( (ozf_i*ozs_i) ==0 ? 0 : (op_i*on_i)/(ozf_i*ozs_i)).to_f
    end
    @second_c = sum_tr
  	th1 =(nepr1+nepr2+nepr3+nepr4) ==0 ? 0 : (4*nepr1 + 3*nepr2 + 2*nepr3 + 1*nepr4)/(nepr1+nepr2+nepr3+nepr4).to_f
  	th2 =(nep1+nep2+nep3+nep4) ==0 ? 0 : (4*nep1 + 3*nep2 + 2*nep3 + 1*nep4)/(nep1+nep2+nep3+nep4).to_f / 2
    @first_c = (@first_c * 100).round / 100.0
    @second_c = (@second_c * 100).round / 100.0
    @third_c = ((th1 +th2)*100).round / 100.0
  	((@second_c*@first_c/@third_c)*100).round / 100.0

  	# oppsh_i=(1*oppsh1+2*oppsh2+3*oppsh3)/(oppsh1+oppsh2+oppsh3)

  end
end
