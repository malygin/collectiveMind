class Core::Knowbase::Post < ActiveRecord::Base
  validates_presence_of :title

  belongs_to :project, class_name: "Core::Project"
  belongs_to :core_aspect, class_name: 'Core::Aspect::Post', foreign_key: :aspect_id
  scope :stage_knowbase_order, ->(project) { where(project_id: project).order(:stage) }
  scope :stage_knowbase_post, ->(project, id) { where(project_id: project, id: id) }

  def self.knowbase_posts_sort(sortable)
    sortable.each { |k, v| self.find(k.to_i).update_attributes!(stage: v.to_i) }
  end

  def self.min_stage_knowbase_post(project)
    where(project_id: project).where(stage: self.stage_knowbase_order(project).minimum(:stage))
  end
end
