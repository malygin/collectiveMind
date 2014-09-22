class Concept::Resource < ActiveRecord::Base
  attr_accessible :desc, :name, :project_id
  belongs_to :project, class_name: "Core::Project"

end
