class Discontent::PostAdvice < ActiveRecord::Base
  belongs_to :user
  belongs_to :discontent_post, class_name: 'Discontent::Post'
  has_many :comments, class_name: 'Discontent::PostAdviceComment'
  #@todo remove
  attr_accessible :content, :approved

  scope :unapproved, -> { where approved: false }
  scope :approve, -> { where approved: true }
  scope :by_project, -> (project) { joins(:discontent_post).where discontent_posts: {project_id: project.id} }
end
