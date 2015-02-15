class CollectInfo::UserAnswers < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer
  belongs_to :question
  belongs_to :aspect
  belongs_to :project
  scope :by_project, ->(project) { where(collect_info_user_answers: {project_id: project}) }
  scope :by_user, ->(user) { where(collect_info_user_answers: {user_id: user}) }

  validates :answer_id, :question_id, :aspect_id, :project_id, :user_id, presence: true
end