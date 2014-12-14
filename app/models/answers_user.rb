class AnswersUser < ActiveRecord::Base
  attr_accessible :user, :answer_id
  belongs_to :answer
  belongs_to :user
end