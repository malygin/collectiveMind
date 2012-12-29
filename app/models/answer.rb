class Answer < ActiveRecord::Base
  attr_accessible  :raiting, :text, :user_id
  belongs_to :user
  belongs_to :question
   #voiting system
  has_and_belongs_to_many :users
  default_scope :order => 'answers.created_at ASC'

end
