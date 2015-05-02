class Core::ContentQuestion < ActiveRecord::Base
  belongs_to :project, :class_name => 'Core::Project', :foreign_key => 'project_id'
  has_many :answers,  class_name: 'Core::ContentAnswer'
  has_many :user_answers, class_name: 'Core::ContentUserAnswer', foreign_key: :question_id
end
