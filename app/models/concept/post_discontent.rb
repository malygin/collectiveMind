class Concept::PostDiscontent < ActiveRecord::Base
  belongs_to :post
  belongs_to :discontent_post
  scope :by_concept,->(p){ where(post_id: p) unless p.nil? }
  scope :by_discontent,->(p){ where(discontent_post_id: p) unless p.nil? }
end
