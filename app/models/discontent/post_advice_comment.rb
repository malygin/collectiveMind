class Discontent::PostAdviceComment < ActiveRecord::Base
  belongs_to :post_advice
  belongs_to :user
  belongs_to :post_advice_comment
  has_many :comments, class_name: 'Discontent::PostAdviceComment'
end
