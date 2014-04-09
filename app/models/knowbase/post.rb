class Knowbase::Post < ActiveRecord::Base
  attr_accessible :content, :title, :stage

  validates :content, presence: true
  validates :title, presence: true
  validates :stage, presence: true

  belongs_to :project, :class_name => "Core::Project"

  scope :stage_knowbase_order, ->(project) { where(:project_id => project).order(:stage) }
  scope :stage_knowbase_post, ->(project,id) { where(:project_id => project, :id => id) }
  scope :min_stage_knowbase_post, ->(project) { where(:project_id => project, :stage => self.minimum(:stage)) }

  def self.set_knowbase_posts_sort(sortable)
    sortable.each {|k,v| self.find(k.to_i).update_attributes!(:stage => v.to_i)}
  end

end
