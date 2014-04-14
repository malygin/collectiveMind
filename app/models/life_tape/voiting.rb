class LifeTape::Voiting < ActiveRecord::Base
    attr_accessible  :user
    belongs_to :user
	  belongs_to :discontent_aspect
   #scope by_project, ->(project_id) { where("project_id = ?", project_id) }
end
