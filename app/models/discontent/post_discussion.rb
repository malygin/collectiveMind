class Discontent::PostDiscussion < ActiveRecord::Base
  attr_accessible :aspect, :post, :user
  belongs_to :user
  belongs_to :post, class_name: 'Discontent::Post'
  belongs_to :aspect, class_name: 'Discontent::Aspect'
end
