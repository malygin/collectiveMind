class Concept::PostDiscontent < ActiveRecord::Base
  attr_accessible :discontent_post_id, :post_id
  belongs_to :post
  belongs_to :discontent_post
end
