class LifeTape::PostDiscussion < ActiveRecord::Base
  attr_accessible  :user, :post, :aspect
  belongs_to :user
  belongs_to :post, class_name: 'LifeTape::Post'
  belongs_to :aspect, class_name: 'Discontent::Aspect'
end