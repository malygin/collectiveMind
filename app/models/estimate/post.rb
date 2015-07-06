class Estimate::Post < ActiveRecord::Base
  include BasePost

  belongs_to :post, class_name: 'Plan::Post'
  belongs_to :project, class_name: 'Core::Project'

  validates :user_id, :post_id, :status, :project_id, presence: true
end
