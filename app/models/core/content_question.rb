class Core::ContentQuestion < ActiveRecord::Base
  belongs_to :project, :class_name => 'Core::Project', :foreign_key => 'project_id'
  has_many :answers,  class_name: 'Core::ContentAnswer'
  has_many :user_answers, class_name: 'Core::ContentUserAnswer', foreign_key: :content_question_id

  def has_no_answer_for_post_and_user?(post_id, user)
    self.user_answers.where(post_id: post_id, user_id: user).count == 0
  end

end

