class Concept::PostResource < ActiveRecord::Base
  attr_accessible :desc, :name
  belongs_to :concept_post, :class_name => 'Concept::Post'
  belongs_to :concept_resource, :class_name => 'Concept::Resource'
end
