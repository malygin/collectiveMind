class CollectInfo::Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :project, class_name: 'Core::Project'
  belongs_to :core_aspect, class_name: 'Core::Aspect::Post', foreign_key: 'aspect_id'

  has_many :answers, -> { where status: 0 }, class_name: 'CollectInfo::Answer', foreign_key: :question_id
  has_many :user_answers, class_name: 'CollectInfo::UserAnswers', foreign_key: :question_id

  scope :by_project, ->(project) { where(collect_info_questions: { project_id: project.id }) }
  #  status = 0 if question is active, status = 1 unless
  scope :by_status, ->(status) { where(collect_info_questions: { status: status }) }
  scope :by_complete, ->(ids) { where.not(collect_info_questions: { id: ids }) }

  scope :by_type, ->(type) { where(collect_info_questions: { type_stage: type }) }

  validates :content, :project_id, presence: true
  default_scope { order :id }

  def answer_from_type(user, answers, content, skip, type_for_questions)
    # если вопрос пропущен, то просто создаем пустой ответ
    return true if skip
    return false if type_for_questions == 1 && !uncorrect_answers?(answers)
    if  content.present? && type_for_questions == 0
      core_aspect.comments.create!(content: content, user: user, answer_id: answers.try(:first).try(:to_i))
    end
    user.user_answers.where(project_id: project.id, question_id: id,
                              aspect_id: core_aspect.id).first_or_create(answer_id: skip ? nil : answers.try(:first).try(:to_i), content: content)
    return true

  end

  def uncorrect_answers?(answers)
    return false unless answers
    correct_answers = self.answers.by_correct.pluck('collect_info_answers.id')
    answers = answers.collect(&:to_i)
    correct_answers == answers
  end
end
