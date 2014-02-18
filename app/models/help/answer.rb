class Help::Answer < ActiveRecord::Base
  attr_accessible :content, :order
  belongs_to :help_question, :class_name => 'Help::Question', :foreign_key => :question_id
end
