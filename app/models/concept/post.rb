class Concept::Post < ActiveRecord::Base
  include BasePost

  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'concept_post_id', class_name: 'Concept::Voting'

  has_many :concept_post_discontents, -> { where concept_post_discontents: {status: [0, nil]} }, class_name: 'Concept::PostDiscontent'
  has_many :concept_disposts, through: :concept_post_discontents, source: :discontent_post, class_name: 'Discontent::Post'

  # has_many :concept_post_resources, class_name: 'Concept::PostResource'
  has_many :concept_post_discontent_checks, -> { where concept_post_discontents: {status: [1]} }, class_name: 'Concept::PostDiscontent'

  has_many :advices, class_name: 'Advice', as: :adviseable

  validates :title, :user_id, :project_id, presence: true

  scope :by_status, ->(p) { where(status: p) }
  scope :by_project, ->(p) { where(project_id: p) }

  # def self.scope_vote_top(post)
  #   joins(:concept_post_discontents).
  #       where('"concept_post_discontents"."discontent_post_id" = ?', post.id).
  #       joins(:post_aspects).
  #       joins('INNER JOIN "concept_votings" ON "concept_votings"."concept_post_aspect_id" = "concept_post_aspects"."id"').
  #       where('"concept_votings"."discontent_post_id" = "concept_post_aspects"."core_aspect_id"')
  #       .group('"concept_posts"."id"')
  #       .order('count("concept_votings"."user_id") DESC')
  # end

  def complite(discontent)
    post = discontent.concept_post_discontents.by_concept(self).first
    post.complite if post
  end

  def note_size?(type_fd)
    self.post_notes(type_fd).size > 0
  end

  def update_status_fields(pa)
  end

  def fullness_title
    0
  end

  def update_statuses
    statuses = []
    if content.present?
      statuses << 'content'
    end
    statuses
  end
end
