class Concept::PostAspectDiscontent < ActiveRecord::Base
  attr_accessible :content, :control, :discontent_post_id, :name, :negative, :positive, :post_aspect_id
  belongs_to :post_aspect
end
