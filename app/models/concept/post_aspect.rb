class Concept::PostAspect < ActiveRecord::Base
  attr_accessible :discontent_aspect_id, :concept_post_id, :content, :control,
                  :name, :negative, :positive, :reality, :problems

  belongs_to :concept_post, :class_name => 'Concept::Post', :foreign_key => :concept_post_id
  belongs_to :discontent, :class_name => 'Discontent::Post', :foreign_key => :discontent_aspect_id

end
