class Concept::PostDiscontent < ActiveRecord::Base
  belongs_to :post
  belongs_to :discontent_post, class_name: 'Discontent::Post'

  scope :by_concept, ->(concept) { where(post_id: concept.id) }
  scope :by_discontent, ->(discontent) { where(discontent_post_id: discontent.id) }
end
