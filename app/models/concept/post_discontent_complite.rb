class Concept::PostDiscontentComplite < ActiveRecord::Base
  belongs_to :post
  belongs_to :discontent_post

  scope :by_concept,->(p){ where(post_id: p) }
  scope :by_discontent,->(d){ where(discontent_post_id: d) }

end
