class Plan::Post < ActiveRecord::Base
  attr_accessible :first_step, :goal, :number_views, :other_steps, :status
  belongs_to :user
  has_many :comments
  has_many :post_voitings
  has_many :users, :through => :post_voitings
  has_many :post_notes
  has_many :task_triplets, :order => 'position'
  has_many :estimates, :class_name => 'Estimate::Post'
  has_many :voitings, :class_name => "Estimate::FinalVoiting"

  default_scope :order => 'plan_posts.created_at DESC'

 def content_short
   self.user.name_title+ " - "+self.goal[0..70]+" ..."
  end

 def voiting_score
    score = 0
    self.voitings.each do |v|
      score += v.score
    end
    return score
  end
  
end
