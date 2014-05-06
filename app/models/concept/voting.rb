class Concept::Voting < ActiveRecord::Base
  attr_accessible :concept_post_aspect_id, :user_id, :discontent_post_id
  belongs_to :user
  belongs_to :concept_post_aspect, :class_name => 'Concept::PostAspect'
  belongs_to :discontent_post, :class_name => 'Discontent::Post'
end
