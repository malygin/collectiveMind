class Concept::PostDiscontent < ActiveRecord::Base
  attr_accessible :discontent_post_id, :post_id, :complite, :status
  belongs_to :post
  belongs_to :discontent_post
  scope :by_concept,->(p){ where(post_id: p) unless p.nil?}
end
