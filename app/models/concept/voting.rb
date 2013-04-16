class Concept::Voting < ActiveRecord::Base
  attr_accessible :concept_post_id, :user_id
  belongs_to :user
  belongs_to :concept_post
end
