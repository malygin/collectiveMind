class Aspect::Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :project, class_name: 'Core::Project'
  belongs_to :aspect, class_name: 'Aspect::Post', foreign_key: 'aspect_id'

  has_many :answers, -> { where status: 0 }, class_name: 'Aspect::Answer', foreign_key: :question_id
  has_many :user_answers, class_name: 'Aspect::UserAnswer', foreign_key: :question_id

  #  status = 0 if question is active, status = 1 unless
  scope :by_status, ->(status) { where(aspect_questions: { status: status }) }
  scope :by_complete, ->(ids) { where.not(aspect_questions: { id: ids }) }
  scope :by_type, ->(type) { where(aspect_questions: { type_stage: type }) }
  scope :by_project, ->(project) { where(aspect_questions: { project_id: project.id }) }

  validates :content, :project_id, presence: true
  default_scope { order :id }

  def answer_from_type(user, answers, content, skip)
    # если вопрос пропущен, то просто создаем пустой ответ
    return true if skip
    return false if type_stage == 1 && !uncorrect_answers?(answers)
    if content.present? && type_stage == 0
      aspect.comments.create!(content: content, user: user, answer_id: answers.try(:first).try(:to_i))
    end
    user.user_answers.where(project_id: project.id, question_id: id,
                            aspect_id: aspect.id).first_or_create(answer_id: skip ? nil : answers.try(:first).try(:to_i), content: content)
    true
  end

  def uncorrect_answers?(answers)
    return false unless answers
    correct_answers = self.answers.by_correct.pluck('aspect_answers.id')
    answers = answers.collect(&:to_i)
    correct_answers == answers
  end
end
