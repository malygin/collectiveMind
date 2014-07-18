class Plan::PostActionResource < ActiveRecord::Base
  attr_accessible :desc, :name, :post_action, :resource_id, :project_id
  belongs_to :post_action, :class_name => 'Plan::PostAction', :foreign_key => :post_action_id
  belongs_to :project, :class_name => "Core::Project"
  scope :by_project, ->(p){ where(project_id: p) }
end
