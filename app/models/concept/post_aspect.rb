class Concept::PostAspect < ActiveRecord::Base
  attr_accessible :discontent_aspect_id, :concept_post_id
  has_many :post_aspect_discontents
  belongs_to :discontent_aspect
  belongs_to :post

end
