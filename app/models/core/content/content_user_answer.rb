class Core::Content::UserAnswer < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer, class_name: 'Core::Content::Answer'
  belongs_to :question, class_name: 'Core::Content::Question'
end
