class AdviceComment < ActiveRecord::Base
  belongs_to :advice
  belongs_to :user
  belongs_to :advice_comment
  has_many :comments, class_name: 'AdviceComment', foreign_key: :post_advice_comment_id

  scope :main, -> { where post_advice_comment_id: nil }

  #@todo remove
  attr_accessible :content, :post_advice_comment_id

  def main_comment?
    post_advice_comment_id.nil?
  end
end
