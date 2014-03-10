class Knowbase::Post < ActiveRecord::Base
  attr_accessible :content, :title, :stage

  belongs_to :project, :class_name => "Core::Project"
end
