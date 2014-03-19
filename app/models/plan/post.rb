class Plan::Post < ActiveRecord::Base
   include BasePost
  attr_accessible :first_step, :goal, :other_steps, :plan_first, :plan_other,:plan_control, :step  #for form master

   #has_many :task_triplets, :order => 'position'

   has_many :post_aspects_first, :foreign_key => 'plan_post_id', :class_name => 'Plan::PostAspect',
            :conditions => {:first_stage => 1}
   has_many :post_aspects_other, :foreign_key => 'plan_post_id', :class_name => 'Plan::PostAspect',
            :conditions =>  {:first_stage => 0}

   has_many :post_aspects, :foreign_key => 'plan_post_id', :class_name => 'Plan::PostAspect'

   has_many :post_first_conds, :class_name => 'Plan::PostFirstCond', :foreign_key => :plan_post_id

   has_many :estimates, :class_name => 'Estimate::Post'
   has_many :voted_users, :through => :final_votings, :source => :user
   has_many :final_votings,:foreign_key => 'plan_post_id', :class_name => "Plan::Voting"
   def voted(user)
     self.voted_users.where(:id => user)
   end
  def content
  	self.goal
  end

end
