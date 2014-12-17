class Discontent::PostWhere < ActiveRecord::Base
  belongs_to :project, class_name: 'Core::Project'

end
