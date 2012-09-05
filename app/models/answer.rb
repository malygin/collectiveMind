class Answer < ActiveRecord::Base
  attr_accessible  :raiting, :text, :user_id
  belongs_to :user
  belongs_to :question
end
