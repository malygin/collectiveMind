class Core::ProjectScore < ActiveRecord::Base
  attr_accessible :project_id, :score, :score_a, :score_g, :score_o, :user_id
  belongs_to :core_project,  :class_name => "Core::Project",  :foreign_key => "project_id"
  belongs_to :user

  scope :user_scores, ->(pr,sn) { where(:project_id => pr).where("#{sn}>0").order("#{sn} DESC") }
  scope :by_project, ->(pr){where(:project_id => pr)}
end
