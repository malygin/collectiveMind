class Concept::Voting < ActiveRecord::Base
  attr_accessible :concept_post_aspect_id, :user_id, :user
  belongs_to :user
  belongs_to :concept_post_aspect, :class_name => 'Concept::PostAspect'
end
