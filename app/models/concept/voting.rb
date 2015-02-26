class Concept::Voting < ActiveRecord::Base
  attr_accessible :concept_post_aspect_id, :user_id, :discontent_post_id
  belongs_to :user
  belongs_to :concept_post_aspect, class_name: 'Concept::PostAspect'
  belongs_to :discontent_post, class_name: 'Discontent::Post'

  scope :uniq_user, -> { select('distinct concept_votings.user_id') }
  scope :by_dispost, ->(p) { where(discontent_post_id: p) }
  scope :by_concept_aspect, ->(p) { where(concept_post_aspect_id: p) }
  scope :by_posts_vote, ->(posts) { where("concept_votings.discontent_post_id IN (#{posts})") unless posts.empty? }
  scope :not_admins, -> { joins(:user).where("users.type_user NOT IN (?) or users.type_user IS NULL", User::TYPES_USER[:admin]) }

  def self.by_project_votings(project)
    joins(:discontent_post).
        where('"discontent_posts"."project_id" = ?', project.id)
  end
end
