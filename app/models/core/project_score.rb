class Core::ProjectScore < ActiveRecord::Base
  belongs_to :core_project, class_name: 'Core::Project', foreign_key: 'project_id'
  belongs_to :user

  scope :user_scores, ->(pr, sn) { where(project_id: pr).where('? > 0', sn).order('? DESC', sn) }
  scope :by_project, ->(pr) { where(project_id: pr) }
end
