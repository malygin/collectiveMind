class Concept::Resource < ActiveRecord::Base
  attr_accessible :desc, :name
  belongs_to :project, :class_name => "Core::Project"

end
