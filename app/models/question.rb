class Question < ActiveRecord::Base
  # attr_accessible :post, :user, :project, :parent_post_type, :hint, :status, :content
  belongs_to :post
  belongs_to :user
  belongs_to :project
  has_many :answers, class_name: 'Answer', foreign_key: :question_id
  has_many :answers_users, class_name: 'AnswersUser', foreign_key: :question_id

  scope :by_project, ->(project) { where(questions: {project_id: project}) }
  scope :by_status, ->(status) { where(questions: {status: status}) }
  scope :by_complete, ->(ids) { where.not(questions: {id: ids}) }
end