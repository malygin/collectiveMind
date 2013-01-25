class Estimate::Forecast < ActiveRecord::Base
  attr_accessible :best_jury_post, :best_student_post, :user

  belongs_to :user
  belongs_to :best_student_post, :class_name => "Plan::Post"
  belongs_to :best_jury_post, :class_name => "Plan::Post"

end
