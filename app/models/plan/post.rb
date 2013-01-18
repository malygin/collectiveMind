class Plan::Post < ActiveRecord::Base
  attr_accessible :first_step, :goal, :number_views, :other_steps, :status
  belongs_to :user
  has_many :comments
  has_many :post_voitings
  has_many :users, :through => :post_voitings
  has_many :post_notes
  has_many :task_triplets, :order => 'position'
  has_many :estimates, :class_name => 'Estimate::Post'

  default_scope :order => 'plan_posts.created_at DESC'
end
