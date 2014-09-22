class Help::Post < ActiveRecord::Base
  attr_accessible :content, :mini, :style, :stage, :title
  has_many :help_questions, class_name: 'Help::Question'
end
