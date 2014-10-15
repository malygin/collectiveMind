class Advice < ActiveRecord::Base
  belongs_to :adviseable, polymorphic: true
  belongs_to :user
  belongs_to :discontent_post, -> { where(advices: {adviseable_type: 'Discontent::Post'}) },
             class_name: 'Discontent::Post',
             foreign_key: :adviseable_id
  has_many :comments, class_name: 'AdviceComment', foreign_key: :post_advice_id
  #@todo remove
  attr_accessible :content, :approved, :adviseable_type

  scope :unapproved, -> { where approved: false }
  scope :approve, -> { where approved: true }
  scope :by_project, -> (project) { joins(:discontent_post).where discontent_posts: {project_id: project.id} }

  def discontent?
    adviseable_type == 'Discontent::Post'
  end

  def concept?
    adviseable_type == 'Concept::Post'
  end
end
