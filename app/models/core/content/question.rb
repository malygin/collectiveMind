class Core::Content::Question < ActiveRecord::Base
  belongs_to :project, class_name: 'Core::Project', foreign_key: 'project_id'
  has_many :answers,  class_name: 'Core::Content::Answer', foreign_key: :content_question_id
  has_many :user_answers, class_name: 'Core::Content::UserAnswer', foreign_key: :content_question_id

  def no_answer_for_post_and_user?(post_id, user)
    user_answers.where(post_id: post_id, user_id: user).count == 0
  end
end
