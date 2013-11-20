class Plan::Post < ActiveRecord::Base
   include BasePost
  attr_accessible :first_step, :goal, :other_steps, :step  #for form master

   #has_many :task_triplets, :order => 'position'

   has_many :post_aspects_first, :foreign_key => 'plan_post_id', :class_name => 'Plan::PostAspect',
            :conditions => {:first_stage => 1}
   has_many :post_aspects_other, :foreign_key => 'plan_post_id', :class_name => 'Plan::PostAspect',
            :conditions =>  {:first_stage => 0}

   has_many :post_aspects, :foreign_key => 'plan_post_id', :class_name => 'Plan::PostAspect'

   has_many :estimates, :class_name => 'Estimate::Post'

  def content
  	self.goal
  end

end
