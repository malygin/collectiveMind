class Discontent::PostWhere < ActiveRecord::Base
  attr_accessible :content
  belongs_to :project, :class_name => "Core::Project"

end