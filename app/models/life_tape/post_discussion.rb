class LifeTape::PostDiscussion < ActiveRecord::Base
  attr_accessible  :user, :post
  belongs_to :user
  belongs_to :post, :class_name => 'LifeTape::Post'
end