class Knowbase::Post < ActiveRecord::Base
  attr_accessible :content, :title, :stage

  belongs_to :project, :class_name => "Core::Project"

  scope :stage_knowbase_order, ->(project) { where(:project_id => project).order(:stage) }
  scope :stage_knowbase_post, ->(project,stage) { where(:project_id => project, :stage => stage) }

  def self.set_knowbase_posts_sort(sortable)
    sortable.each do |sort|
      self.where(:id => sort[1][0].to_i).first.update_attributes!(:stage => sort[1][1].to_i)
    end
  end

end
