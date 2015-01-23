class Poll::AnswersUser < ActiveRecord::Base
  belongs_to :answer
  belongs_to :user
  scope :by_project, ->(project) { where(answers_users: {project_id: project}) }
  scope :by_user, ->(user) { where(answers_users: {user_id: user}) }
end