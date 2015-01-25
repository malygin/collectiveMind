class CollectInfo::AnswersUser < ActiveRecord::Base
  belongs_to :answer
  belongs_to :user
  scope :by_project, ->(project) { where(collect_info_answers_users: {project_id: project}) }
  scope :by_user, ->(user) { where(collect_info_answers_users: {user_id: user}) }

  validates :answer_id, :question_id, :project_id, :user_id, presence: true
end