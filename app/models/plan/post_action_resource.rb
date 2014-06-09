class Plan::PostActionResources < ActiveRecord::Base
  attr_accessible :desc, :name, :post_action, :resource_id
  belongs_to :post_action, :class_name => 'Plan::PostAction', :foreign_key => :post_action_id
end
