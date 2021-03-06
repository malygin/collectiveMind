class Aspect::UserAnswer < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer
  belongs_to :question
  belongs_to :aspect, class_name: 'Aspect::Post'
  belongs_to :project, class_name: 'Core::Project'

  validates :question_id, :aspect_id, :project_id, :user_id, presence: true

  scope :by_project, ->(project) { where(aspect_user_answers: { project_id: project.id }) }
  scope :by_user, ->(user) { where(aspect_user_answers: { user_id: user.id }) }
  scope :answered_questions, lambda { |project, user|
    select(' DISTINCT "aspect_user_answers"."question_id" ')
      .joins(:question).where(aspect_questions: { project_id: project, type_stage: project.type_for_questions })
      .where(aspect_user_answers: { user_id: user })
  }
end
