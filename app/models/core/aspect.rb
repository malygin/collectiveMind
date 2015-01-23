class Core::Aspect < ActiveRecord::Base
  include BasePost

  has_many :posts
  has_many :discontent_posts, class_name: 'Discontent::Post'
  scope :positive_posts, -> { joins(:discontent_posts).where('discontent_posts.style = ?', 0) }
  scope :negative_posts, -> { joins(:discontent_posts).where('discontent_posts.style = ?', 1) }
  scope :accepted_posts, -> { joins(:discontent_posts).where('discontent_posts.style = ?', 4) }
  has_many :knowbase_posts, class_name: 'Core::Knowbase::Post'
  has_many :discontent_post_aspects, class_name: 'Discontent::PostAspect'
  has_many :aspect_posts, through: :discontent_post_aspects, source: :post, class_name: 'Discontent::Post'

  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'discontent_aspect_id', class_name: 'LifeTape::Voiting'

  has_many :core_aspects, class_name: 'Core::Aspect', foreign_key: 'core_aspect_id'
  belongs_to :core_aspect, class_name: 'Core::Aspect', foreign_key: 'core_aspect_id'

  has_many :questions, -> { where questions: {parent_post_type: 'core_aspect'} }, class_name: 'Util::Poll::Question', foreign_key: 'post_id'

  scope :by_project, ->(project_id) { where("core_aspects.project_id = ?", project_id) }
  scope :minus_view, ->(aspects) { where("core_aspects.id NOT IN (#{aspects.join(", ")})") unless aspects.empty? }
  scope :main_aspects, -> { where(core_aspects: {core_aspect_id: nil}) }

  scope :vote_top, ->(revers) {
    if revers == "0"
      order('count("life_tape_voitings"."user_id") DESC')
    elsif revers == "1"
      order('count("life_tape_voitings"."user_id") ASC')
    else
      nil
    end
  }
  validates :project_id, presence: true

  def voted(user)
    self.voted_users.where(id: user)
  end

  def self.scope_vote_top(project, revers)
    includes(:final_votings).
        group('"core_aspects"."id","life_tape_voitings"."id"').
        where('"core_aspects"."project_id" = ? and "core_aspects"."status" = 0', project)
        .references(:life_tape_voitings)
        .vote_top(revers)
  end

  def to_s
    self.content
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

  def question_complete(project, user)
    self.questions.joins("INNER JOIN poll_answers_users ON poll_answers_users.question_id = questions.id").where('poll_answers_users.user_id = ?', user.id).by_project(project.id).by_status(0).select("distinct questions.id")
  end

  def color
    color = read_attribute(:color)
    color.present? ? color : '#eac85e'
  end
end
