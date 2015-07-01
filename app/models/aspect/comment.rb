class Aspect::Comment < ActiveRecord::Base
  include BaseComment

  belongs_to :answer, class_name: 'Aspect::Answer', foreign_key: 'answer_id'
end
