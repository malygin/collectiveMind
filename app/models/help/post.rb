class Help::Post < ActiveRecord::Base
  has_many :help_questions, class_name: 'Help::Question'
end
