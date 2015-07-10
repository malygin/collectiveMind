class Core::Knowbase::Post < ActiveRecord::Base
  validates_presence_of :title

  belongs_to :project, class_name: 'Core::Project'
  belongs_to :aspect, class_name: 'Aspect::Post', foreign_key: :aspect_id
  scope :stage_knowbase_order, ->(project) { where(project_id: project).order(:stage) }
  scope :stage_knowbase_post, ->(project, id) { where(project_id: project, id: id) }
end
