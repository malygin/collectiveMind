class Advice < ActiveRecord::Base
  belongs_to :adviseable, polymorphic: true
  belongs_to :user
  belongs_to :project, class_name: 'Core::Project'
  has_many :comments, class_name: 'AdviceComment', foreign_key: :post_advice_id

  scope :unapproved, -> { where approved: nil }
  scope :approve, -> { where approved: true }
  scope :disapproved, -> { where approved: false }
  scope :by_project, -> (project) { where project_id: project.id }

  def discontent?
    adviseable_type == 'Discontent::Post'
  end

  def concept?
    adviseable_type == 'Concept::Post'
  end

  def disapproved?
    approved === false
  end

  def unapproved?
    approved === nil
  end

  def not_useful?
    useful === nil
  end

  def notify_moderators(project, from_user)
    project.moderators.each do |user|
      from_user.journals.build(type_event: 'my_new_advices_in_project', user_informed: user, project: project,
                               body: content[0..100], personal: true, viewed: false).save!
    end
  end
end
