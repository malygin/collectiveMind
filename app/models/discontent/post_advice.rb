class Discontent::PostAdvice < ActiveRecord::Base
  belongs_to :user
  belongs_to :discontent_post, class_name: 'Discontent::Post'
  #@todo remove
  attr_accessible :content

  scope :unapproved, -> { where approved: false }
  #scope :by_project, -> (project) { joins(:discontent_post).where discontent_post: {project_id: project.id} }
end
