class Estimate::Post < ActiveRecord::Base
  include BasePost

  # 0 - new post, 1 - accepted post, 2 - declined post
  attr_accessible :imp, :nepr, :nepr1, :nepr2, :nepr3, :nepr4,
                  :nep, :nep1, :nep2, :nep3, :nep4, :all_grade,
                  :onpsh, :onpsh1, :onpsh2, :onpsh3, :oppsh, :oppsh1, :oppsh2, :oppsh3, :ozpshf, :ozpshf1, :ozpshf2, :ozpshf3, :ozpshs, :ozpshs1, :ozpshs2, :ozpshs3
  attr_accessor :first_c, :second_c, :third_c, :max_score, :sum_score

  belongs_to :post, class_name: 'Plan::Post'

  has_many :post_aspects
  has_many :plan_post_aspects, class_name: 'Plan::PostAspect'
  has_many :post_aspects_all, foreign_key: 'post_id', class_name: 'Estimate::PostAspect'

  # @todo кандидат на удаление, нигде не используется?
  #has_many :post_aspects_other, -> { where first_stage: false }, foreign_key: 'post_id', class_name: 'Estimate::PostAspect'
  #has_many :post_aspects_first, -> { where first_stage: true }, foreign_key: 'post_id', class_name: 'Estimate::PostAspect'

  #@todo replace sum in product
  def score(status)
    if status.nil? or status == 0
      sum_tr=0.0
      count = 0
      sum_all =0
      post_aspects.others(self.post).each do |tr|
        op_i=(tr.op1+tr.op2+tr.op3+tr.op4) ==0 ? 0 : (4*tr.op1+3*tr.op2+2*tr.op3+tr.op4)/(tr.op1+tr.op2+tr.op3+tr.op4)
        on_i=(tr.on1+tr.on2+tr.on3+tr.on4) ==0 ? 0 : (4*tr.on1+3*tr.on2+2*tr.on3+tr.op4)/(tr.on1+tr.on2+tr.on3+tr.on4)
        ozf_i=(tr.ozf1+tr.ozf2+tr.ozf3+tr.ozf4) ==0 ? 0 : (4*tr.ozf1+3*tr.ozf2+2*tr.ozf3+tr.ozf4)/(tr.ozf1+tr.ozf2+tr.ozf3+tr.ozf4)
        ozs_i=(tr.ozs1+tr.ozs2+tr.ozs3+tr.ozs4) ==0 ? 0 : (4*tr.ozs1+3*tr.ozs2+2*tr.ozs3+tr.ozs4)/(tr.ozs1+tr.ozs2+tr.ozs3+tr.ozs4)
        sum_tr = sum_tr + ((ozf_i*ozs_i) ==0 ? 0 : (op_i*on_i)/(ozf_i*ozs_i))
        count+=1

      end
      #puts "__________", sum_tr
      @first_c = sum_tr
      sum_tr=0.0
      post_aspects.firsts(self.post).each do |tr|
        op_i=(tr.op1+tr.op2+tr.op3+tr.op4) ==0 ? 0 : (4*tr.op1+3*tr.op2+2*tr.op3+tr.op4)/(tr.op1+tr.op2+tr.op3+tr.op4)
        on_i=(tr.on1+tr.on2+tr.on3+tr.on4) ==0 ? 0 : (4*tr.on1+3*tr.on2+2*tr.on3+tr.op4)/(tr.on1+tr.on2+tr.on3+tr.on4)
        ozf_i=(tr.ozf1+tr.ozf2+tr.ozf3+tr.ozf4) ==0 ? 0 : (4*tr.ozf1+3*tr.ozf2+2*tr.ozf3+tr.ozf4)/(tr.ozf1+tr.ozf2+tr.ozf3+tr.ozf4)
        ozs_i=(tr.ozs1+tr.ozs2+tr.ozs3+tr.ozs4) ==0 ? 0 : (4*tr.ozs1+3*tr.ozs2+2*tr.ozs3+tr.ozs4)/(tr.ozs1+tr.ozs2+tr.ozs3+tr.ozs4)
        sum_tr = sum_tr + ((ozf_i*ozs_i) ==0 ? 0 : (op_i*on_i)/(ozf_i*ozs_i))
        count+=1
      end

      @second_c = sum_tr
      th1 =(nepr1+nepr2+nepr3+nepr4) ==0 ? 0 : (4*nepr1 + 3*nepr2 + 2*nepr3 + 1*nepr4)/(nepr1+nepr2+nepr3+nepr4).to_f
      th2 =(nep1+nep2+nep3+nep4) ==0 ? 0 : (4*nep1 + 3*nep2 + 2*nep3 + 1*nep4)/(nep1+nep2+nep3+nep4).to_f
      @first_c = (@first_c * 100).round / 100.0
      @second_c = (@second_c * 100).round / 100.0
      @third_c = ((th1 + th2)*100).round / 100.0
      @max_score = ((count.to_f * 2.86 / (2 * 1.86)) *100).round / 100.0
      sum_all = @first_c+@second_c
      sum_all /= @third_c if @third_c != 0.0

      @max_score == 0 ? 0 : ((sum_all*100/ @max_score) *100).round / 100.0
    else
      sum_tr=0.0
      count = 0
      sum_all =0
      post_aspects.others(self.post).each do |tr|
        op_i = tr.op1
        on_i = tr.on1
        ozf_i = tr.ozf1
        ozs_i = tr.ozs1
        count+=1
        if not (op_i.nil? or on_i.nil? or ozf_i.nil? or ozs_i.nil?)
          sum_tr = ((ozf_i*ozs_i) ==0 ? 0 : (op_i*on_i)/(ozf_i*ozs_i))
          if sum_tr > 1
            sum_all += (sum_tr *50/16)+50
          else
            sum_all += sum_tr * 50
          end
        end
      end

      @first_c = sum_tr
      sum_tr=0.0
      post_aspects.firsts(self.post).each do |tr|
        op_i = tr.op1
        on_i = tr.on1
        ozf_i = tr.ozf1
        ozs_i = tr.ozs1
        count+=1
        if not (op_i.nil? or on_i.nil? or ozf_i.nil? or ozs_i.nil?)
          sum_tr = ((ozf_i*ozs_i) ==0 ? 0 : (op_i*on_i)/(ozf_i*ozs_i))
          if sum_tr > 1
            sum_all += (sum_tr *50/16)+50
          else
            sum_all += sum_tr * 50
          end
        end
      end

      @second_c = sum_tr
      th1 = nepr1.nil? ? 0 : nepr1
      th2 = nep1.nil? ? 0 : nep1
      @first_c = (@first_c * 100).round / 100.0
      @second_c = (@second_c * 100).round / 100.0
      @third_c = (th1.nil? or th2.nil?) ? 0.0 : ((th1 + th2)*100).round / 100.0
      @max_score = count * 50
      sum_all /= @third_c if @third_c != 0.0
      # result = @third_c == 0 ? 0.0 : ((@second_c+@first_c)/@third_c)
      @max_score == 0 ? 0 : ((sum_all*100/ @max_score) *100).round / 100.0
    end
    # oppsh_i=(1*oppsh1+2*oppsh2+3*oppsh3)/(oppsh1+oppsh2+oppsh3)
  end
end
