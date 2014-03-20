class Knowbase::Post < ActiveRecord::Base
  attr_accessible :content, :title, :stage

  belongs_to :project, :class_name => "Core::Project"

  scope :stage_knowbase_order, ->(project) { where(:project_id => project).order(:stage) }
  scope :stage_knowbase_post, ->(project,stage) { where(:project_id => project, :stage => stage) }

end
