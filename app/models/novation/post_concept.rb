class Novation::PostConcept < ActiveRecord::Base
  belongs_to :post
  belongs_to :concept_post, class_name: 'Concept::Post'

  scope :by_novation, ->(novation) { where(post_id: novation.id) }
  scope :by_concept, ->(concept) { where(concept_post_id: concept.id) }
end
