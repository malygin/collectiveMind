class AdviceComment < ActiveRecord::Base
  belongs_to :advice, foreign_key: :post_advice_id
  belongs_to :user

  #@todo remove
  attr_accessible :content
end
