class Concept::Post < ActiveRecord::Base
  include BasePost
  SCORE = 70

  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'concept_post_id', class_name: 'Concept::Voting'

  has_many :concept_post_discontents, class_name: 'Concept::PostDiscontent'
  has_many :concept_disposts, through: :concept_post_discontents, source: :discontent_post, class_name: 'Discontent::Post'

  has_many :concept_post_discontent_checks, -> { where concept_post_discontents: { status: [1] } }, class_name: 'Concept::PostDiscontent'

  validates :title, presence: true

  scope :for_discontents, ->(discontents) { where(concept_post_discontents: { discontent_post_id: discontents }) }

  # def self.scope_vote_top(post)
  #   joins(:concept_post_discontents).
  #       where('"concept_post_discontents"."discontent_post_id" = ?', post.id).
  #       joins(:post_aspects).
  #       joins('INNER JOIN "concept_votings" ON "concept_votings"."concept_post_aspect_id" = "concept_post_aspects"."id"').
  #       where('"concept_votings"."discontent_post_id" = "concept_post_aspects"."aspect_id"')
  #       .group('"concept_posts"."id"')
  #       .order('count("concept_votings"."user_id") DESC')
  # end

  def note_size?(type_fd)
    post_notes(type_fd).size > 0
  end

  def update_statuses
    statuses = []
    statuses << 'content' if content.present?
    statuses
  end
end
