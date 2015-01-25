class Core::UserAward < ActiveRecord::Base
  belongs_to :award
  belongs_to :project, class_name: 'Core::Project'
  belongs_to :user
  validates :award_id, :user_id, :project_id, presence: true
end
