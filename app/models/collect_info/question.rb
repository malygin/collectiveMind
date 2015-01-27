class CollectInfo::Question < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :project
  has_many :answers, class_name: 'CollectInfo::Answer', foreign_key: :question_id
  has_many :answers_users, class_name: 'CollectInfo::AnswersUser', foreign_key: :question_id

  scope :by_project, ->(project) { where(collect_info_questions: {project_id: project}) }
  scope :by_status, ->(status) { where(collect_info_questions: {status: status}) }
  scope :by_complete, ->(ids) { where.not(collect_info_questions: {id: ids}) }

  validates :content, :post_id, :project_id, presence: true
end