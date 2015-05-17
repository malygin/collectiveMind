class Estimate::Post < ActiveRecord::Base
  include BasePost

  belongs_to :post, class_name: 'Plan::Post'
  belongs_to :project, class_name: 'Core::Project'

  has_many :post_aspects
  has_many :post_aspects_all, foreign_key: 'post_id', class_name: 'Estimate::PostAspect'

  validates :user_id, :post_id, :status, :project_id, presence: true
end
