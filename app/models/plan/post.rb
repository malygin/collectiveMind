class Plan::Post < ActiveRecord::Base
  attr_accessible :first_step, :goal, :number_views, :other_steps, :status
  belongs_to :user
  has_many :comments
  has_many :post_voitings
  has_many :users, :through => :post_voitings
  default_scope :order => 'plan_posts.created_at DESC'
end
