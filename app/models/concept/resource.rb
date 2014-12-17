class Concept::Resource < ActiveRecord::Base
  belongs_to :project, class_name: 'Core::Project'
end
