class Discontent::Aspect < ActiveRecord::Base
  include BasePost

  attr_accessible :short_desc, :status, :position
  has_many :posts
  has_many :discontent_posts, class_name: 'Discontent::Post'
  scope :positive_posts, -> { joins(:discontent_posts).where('discontent_posts.style = ?', 0) }
  scope :negative_posts, -> { joins(:discontent_posts).where('discontent_posts.style = ?', 1) }
  scope :accepted_posts, -> { joins(:discontent_posts).where('discontent_posts.style = ?', 4) }
  has_many :knowbase_posts, class_name: 'Knowbase::Post'
  has_many :life_posts, class_name: 'LifeTape::Post', foreign_key: 'aspect_id'
  has_many :discontent_post_aspects, class_name: 'Discontent::PostAspect'
  has_many :aspect_posts, through: :discontent_post_aspects, source: :post, class_name: 'Discontent::Post'

  has_many :life_tape_post_discussions, class_name: 'LifeTape::PostDiscussion'
  has_many :aspect_discussion_users, through: :life_tape_post_discussions, source: :user, class_name: 'User'

  has_many :discontent_post_discussions, class_name: 'Discontent::PostDiscussion'
  has_many :disaspect_discussion_users, through: :discontent_post_discussions, source: :user, class_name: 'User'

  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'discontent_aspect_id', class_name: 'LifeTape::Voiting'

  has_and_belongs_to_many :life_tape_posts, class_name: 'LifeTape::Post', join_table: 'discontent_aspects_life_tape_posts',
                          foreign_key: 'discontent_aspect_id', association_foreign_key: 'life_tape_post_id'

  scope :by_project, ->(project_id) { where("discontent_aspects.project_id = ?", project_id) }
  scope :minus_view, ->(aspects) { where("discontent_aspects.id NOT IN (#{aspects.join(", ")})") unless aspects.empty? }
  scope :by_discussions, ->(aspects) { where("discontent_aspects.id NOT IN (#{aspects.join(", ")})") unless aspects.empty? }

  scope :vote_top, ->(revers) {
        if revers == "0"
          order('count("life_tape_voitings"."user_id") DESC')
        elsif revers == "1"
          order('count("life_tape_voitings"."user_id") ASC')
        else
          nil
        end
      }

  def life_tape_post
    self.life_tape_posts.first
  end

  def voted(user)
    self.voted_users.where(id: user)
  end

  def count_concept
    unless @count_concept
      pr = []
      overpr = {}
      self.aspect_posts.by_status(4).each do |ap|
        if ap.dispost_concepts.size > 1
          pr << 100
          overpr[ap.id] = (ap.dispost_concepts.size - 2) * 50
        else
          pr << (ap.dispost_concepts.size*50)
        end
      end

      if pr.size == 0
        @count_concept =0
      else
        @count_concept = pr.inject(0) { |sum, v| sum + v.abs } / pr.size
      end
    end
    return @count_concept
  end

  def self.scope_vote_top(project, revers)
    includes(:final_votings).
        group('"discontent_aspects"."id","life_tape_voitings"."id"').
        where('"discontent_aspects"."project_id" = ? and "discontent_aspects"."status" = 0', project)
        .references(:life_tape_voitings)
        .vote_top(revers)
  end

  def to_s
    self.content
  end

  def concept_count
    self.aspect_posts.
        joins("INNER JOIN concept_post_discontents ON concept_post_discontents.discontent_post_id = discontent_post_aspects.post_id").
        where("discontent_posts.status = ?", 4)
  end

  def aspect_concept
    Concept::Post.joins(:concept_disposts).
        joins("INNER JOIN discontent_post_aspects ON concept_post_discontents.discontent_post_id = discontent_post_aspects.post_id").
        where("discontent_posts.status = ?", 4).
        where("discontent_post_aspects.aspect_id = ?", self.id)
  end
  def aspect_discontent
    Discontent::Post.joins(:post_aspects).
        where("discontent_post_aspects.aspect_id = ?", self.id)
  end
  def aspect_life_tape
    LifeTape::Comment.joins("INNER JOIN life_tape_posts ON life_tape_comments.post_id = life_tape_posts.id").
        where("life_tape_posts.aspect_id = ?", self.id)
  end
end
