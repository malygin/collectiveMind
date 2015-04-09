class CollectInfo::UserAnswers < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer
  belongs_to :question
  belongs_to :aspect, class_name: 'Core::Aspect'
  belongs_to :project, class_name: 'Core::Project'

  validates :question_id, :aspect_id, :project_id, :user_id, presence: true

  scope :by_project, ->(project) { where(collect_info_user_answers: {project_id: project.id}) }
  scope :by_user, ->(user) { where(collect_info_user_answers: {user_id: user.id}) }
end
