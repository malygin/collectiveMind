class Concept::Voting < ActiveRecord::Base
  belongs_to :user
  belongs_to :concept_post, class_name: 'Concept::Post'
  belongs_to :discontent_post, class_name: 'Discontent::Post'

  validates :user_id, :concept_post_id, presence: true

  scope :uniq_user, -> { select('distinct user_id') }
  scope :by_discontent, ->(discontent) { where(discontent_post_id: discontent.id) }
  scope :by_posts_vote, ->(posts) { where("concept_votings.discontent_post_id IN (#{posts})") unless posts.empty? }
  scope :by_status, ->(status) { where(status: status) }

  def self.by_project_votings(project)
    joins(:discontent_post).
        where('"discontent_posts"."project_id" = ?', project.id)
  end
end
