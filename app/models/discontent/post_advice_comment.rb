class Discontent::PostAdviceComment < ActiveRecord::Base
  belongs_to :post_advice
  belongs_to :user
  belongs_to :post_advice_comment
  has_many :comments, class_name: 'Discontent::PostAdviceComment'

  scope :main, -> { where post_advice_comment_id: nil }

  #@todo remove
  attr_accessible :content, :post_advice_comment_id

  def main_comment?
    post_advice_comment_id.nil?
  end
end
