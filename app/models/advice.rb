class Advice < ActiveRecord::Base
  belongs_to :adviseable, polymorphic: true
  belongs_to :user
  belongs_to :discontent_post, -> { where(advices: {adviseable_type: 'Discontent::Post'}) },
             class_name: 'Discontent::Post',
             foreign_key: :adviseable_id
  has_many :comments, class_name: 'AdviceComment', foreign_key: :post_advice_id
  #@todo remove
  attr_accessible :content, :approved, :adviseable_type, :useful

  scope :unapproved, -> { where approved: nil }
  scope :approve, -> { where approved: true }
  scope :by_project, -> (project) { joins(:discontent_post).where discontent_posts: {project_id: project.id} }

  def discontent?
    adviseable_type == 'Discontent::Post'
  end

  def concept?
    adviseable_type == 'Concept::Post'
  end

  def disapproved?
    !approved
  end

  def notify_moderators(project, from_user)
    project.moderators.each do |user|
      from_user.journals.build(type_event: 'my_new_advices_in_project', user_informed: user, project: project,
                               body: content[0..100], personal: true, viewed: false).save!
    end
  end
end
