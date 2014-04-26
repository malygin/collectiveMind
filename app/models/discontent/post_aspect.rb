class Discontent::PostAspect < ActiveRecord::Base
  attr_accessible :post_id, :aspect_id
  belongs_to :post, :class_name => "Discontent::Post"
  belongs_to :discontent_aspect, :class_name => 'Discontent::Aspect',:foreign_key => :aspect_id
  scope :by_aspect, ->(p){where(aspect_id: p)}
  scope :by_post_aspects, ->(posts){where("discontent_post_aspects.post_id IN (#{posts.join(", ")})")}
end