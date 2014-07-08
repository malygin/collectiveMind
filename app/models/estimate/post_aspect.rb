class Estimate::PostAspect < ActiveRecord::Base
  attr_accessible :imp, :on, :on1, :on2, :on3, :on4,
                  :op, :op1, :op2, :op3, :op4,
                  :ozf, :ozf1, :ozf2, :ozf3,  :ozf4,
                  :ozs, :ozs1, :ozs2, :ozs3,
                  :first_stage, :plan_post_first_cond_id
  attr_accessor :max_score
  belongs_to :post
  belongs_to :plan_post_aspect, :class_name => 'Plan::PostAspect'
  belongs_to :plan_post_first_cond, :class_name => 'Plan::PostFirstCond'
  scope :by_plan_fc, ->(id) { where("plan_post_first_cond_id = ?", id) }
  scope :by_plan_pa, ->(id) { where("plan_post_aspect_id = ?", id) }

  #scope :firsts, -> { where(first_stage: true) }
  #scope :others, -> { where(first_stage: false) }

  scope :firsts, ->(post) { joins(:plan_post_aspect).where("plan_post_aspects.post_stage_id = ?", post.first_stage) }
  scope :others, ->(post) { joins(:plan_post_aspect).where("plan_post_aspects.post_stage_id != ?", post.first_stage) }


   def score(status)
     if status == 0
       if op1!=nil
        op_i=(op1+op2+op3+op4) ==0 ? 0 :  33.33 * (3*op1+2*op2+1*op3)/(op1+op2+op3+op4)
        on_i=(on1+on2+on3+on4) ==0 ? 0 :  33.33 * (3*on1+2*on2+1*on3)/(on1+on2+on3+on4)
        ozf_i=(ozf1+ozf2+ozf3+ozf4) ==0 ? 0 : 33.33 * (3*ozf1+2*ozf2+1*ozf3)/(ozf1+ozf2+ozf3+ozf4)
        ozs_i=(ozs1+ozs2+ozs3+ozs4) ==0 ? 0 : 33.33 * (3*ozs1+2*ozs2+1*ozs3)/(ozs1+ozs2+ozs3+ozs4)
        # op_i=(op1+op2+op3+op4) ==0 ? 0 :  ((5/6.to_f)*op1+(1/2.to_f)*op2+(1/6.to_f)*op3)/(op1+op2+op3+op4).to_f
        # on_i=(on1+on2+on3+on4) ==0 ? 0 :   ((5/6.to_f)*on1+(1/2.to_f)*on2+(1/6.to_f)*on3)/(on1+on2+on3+on4).to_f
        # ozf_i=(ozf1+ozf2+ozf3+ozf4) ==0 ? 0 : ((5/6.to_f)*ozf1+(1/2.to_f)*ozf2+(1/6.to_f)*ozf3)/(ozf1+ozf2+ozf3+ozf4).to_f
        # ozs_i=(ozs1+ozs2+ozs3+ozs4) ==0 ? 0 :  ((5/6.to_f)*ozs1+(1/2.to_f)*ozs2+(1/6.to_f)*ozs3)/(ozs1+ozs2+ozs3+ozs4).to_f
        r =  (ozf_i*ozs_i)== 0? 0 : (op_i*on_i)/(ozf_i*ozs_i)
        (r*100).round/100.0
       else
         0
       end
     else
       if not (op1.nil? or on1.nil? or ozf1.nil? or ozs1.nil?)
         op_i=op1
         on_i=on1
         ozf_i=ozf1
         ozs_i=ozs1
         r =  (ozf_i*ozs_i)== 0? 0 : (op_i*on_i)/(ozf_i*ozs_i)

        if r > 1
          (r *50/16)+50
        else
           r * 50
        end

       else
         0
       end
     end
   end
end
