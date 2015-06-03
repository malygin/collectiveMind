class CollectInfo::Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :project, class_name: 'Core::Project'
  belongs_to :core_aspect, class_name: 'Core::Aspect::Post', foreign_key: 'aspect_id'

  has_many :answers, -> { where status: 0 }, class_name: 'CollectInfo::Answer', foreign_key: :question_id
  has_many :user_answers, class_name: 'CollectInfo::UserAnswers', foreign_key: :question_id

  scope :by_project, ->(project) { where(collect_info_questions: {project_id: project.id}) }
  #  status = 0 if question is active, status = 1 unless
  scope :by_status, ->(status) { where(collect_info_questions: {status: status}) }
  scope :by_complete, ->(ids) { where.not(collect_info_questions: {id: ids}) }

  scope :by_type, ->(type) { where(collect_info_questions: {type_stage: type}) }

  validates :content, :project_id, presence: true
  default_scope { order :id }


  def answer_from_type(project, aspect, user, answers, content, skip)
    # если вопрос пропущен, то просто создаем пустой ответ
    unless skip
      # если опрос, то создаем коммент к аспекту и связываем коммент и ответ (если вопрос с ответами)
      if self.type_comment == 0
        aspect.comments.create!(content: content, user: user, answer_id: answers.try(:first).try(:to_i)) if content.present?
      # иначе проверяем наличие ответов (пояснение не обязательно)
      elsif project.type_for_questions == 1 && answers
        # если вопросы с правильными ответами (второй подэтап), то проверка правильности ответов
        wrong = self.uncorrect_answers?(answers)
      end
    end
    # если нет неправильных ответов и ответ не записан
    unless wrong
      user.user_answers.where(project_id: project.id, question_id: self.id, aspect_id: aspect.id).first_or_create(answer_id: skip ? nil : answers.try(:first).try(:to_i), content: content)
    end
    return wrong
  end

  def uncorrect_answers?(answers)
    correct_answers = self.answers.by_correct.pluck("collect_info_answers.id")
    answers = answers.collect { |a| a.to_i }
    (answers - correct_answers).present? || (correct_answers - answers).present?
  end


end
