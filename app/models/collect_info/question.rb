class CollectInfo::Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :project, class_name: 'Core::Project'

  has_many :answers, class_name: 'CollectInfo::Answer', foreign_key: :question_id
  has_many :user_answers, class_name: 'CollectInfo::UserAnswers', foreign_key: :question_id

  scope :by_project, ->(project) { where(collect_info_questions: {project_id: project.id}) }
  #  status = 0 if question is active, status = 1 unless
  scope :by_status, ->(status) { where(collect_info_questions: {status: status}) }
  scope :by_complete, ->(ids) { where.not(collect_info_questions: {id: ids}) }

  validates :content, :project_id, presence: true
end
