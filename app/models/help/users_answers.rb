class Help::UsersAnswers < ActiveRecord::Base
  attr_accessible :answer_id, :user_id
  belongs_to :user
  belongs_to :help_answer, :class_name => 'Help::Answer' , :foreign_key => :answer_id
end
