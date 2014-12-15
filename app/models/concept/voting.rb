class Concept::Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :concept_post_aspect, class_name: 'Concept::PostAspect'
  belongs_to :discontent_post, class_name: 'Discontent::Post'
  scope :uniq_user, -> { select('distinct user_id') }
  scope :by_dispost, ->(p) { where(discontent_post_id: p) }
  scope :by_posts_vote, ->(posts) { where("concept_votings.discontent_post_id IN (#{posts})") unless posts.empty? }

  def self.by_project_votings(project)
    joins(:discontent_post).
        where('"discontent_posts"."project_id" = ?', project.id)
  end
end
