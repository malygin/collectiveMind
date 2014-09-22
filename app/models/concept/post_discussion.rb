class Concept::PostDiscussion < ActiveRecord::Base
  attr_accessible :discontent_post, :post, :user
  belongs_to :user
  belongs_to :post, class_name: 'Concept::Post'
  belongs_to :discontent_post, class_name: 'Discontent::Post'
end
