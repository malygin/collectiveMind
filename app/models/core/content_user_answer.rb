class Core::ContentUserAnswer < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer, class_name: 'Core::ContentAnswer'
  belongs_to :question, class_name: 'Core::ContentQuestion'
end
