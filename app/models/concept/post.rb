class Concept::Post < ActiveRecord::Base
  include BasePost

  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'concept_post_id', class_name: 'Concept::Voting'

  has_many :concept_post_discontents, -> { where concept_post_discontents: {status: [0, nil]} }, class_name: 'Concept::PostDiscontent'
  has_many :concept_disposts, through: :concept_post_discontents, source: :discontent_post, class_name: 'Discontent::Post'
  has_many :concept_post_resources, class_name: 'Concept::PostResource'
  has_many :concept_post_discontent_grouped, -> { where concept_post_discontents: {status: [1]} }, class_name: 'Concept::PostDiscontent'
  has_many :advices, class_name: 'Advice', as: :adviseable

  validates :status, presence: true

  scope :stat_fields_negative, ->(p) { where(id: p).where("status_name = 'f' or status_content = 'f' or status_negative = 'f'
            or status_positive = 'f' or status_control = 'f' or status_obstacles = 'f' or status_reality = 'f' or status_problems = 'f' ") }
  scope :stat_fields_positive, ->(p) { where(id: p).where("status_name = 't' and status_content = 't' and status_negative = 't'
            and status_positive = 't' and status_control = 't' and status_obstacles = 't' and status_reality = 't' and status_problems = 't' ") }
  scope :by_status, ->(p) { where(status: p) }
  scope :by_project, ->(p) { where(project_id: p) }
  scope :by_discussions, ->(posts) { where("concept_posts.id NOT IN (#{posts.join(', ')})") unless posts.empty? }
  scope :posts_for_discussions, ->(p) { where(project_id: p.id, status: 0).where("concept_posts.status_name = 't' and concept_posts.status_content = 't'") }
  scope :by_idea, -> { where("concept_posts.new_fullness <= 40 or concept_posts.new_fullness IS NULL") }
  scope :by_novation, -> { where("concept_posts.new_fullness > 40") }

  def self.scope_vote_top(post)
    joins(:concept_post_discontents).
        where('"concept_post_discontents"."discontent_post_id" = ?', post.id).
        joins(:post_aspects).
        joins('INNER JOIN "concept_votings" ON "concept_votings"."concept_post_aspect_id" = "concept_post_aspects"."id"').
        where('"concept_votings"."discontent_post_id" = "concept_post_aspects"."core_aspect_id"')
        .group('"concept_posts"."id"')
        .order('count("concept_votings"."user_id") DESC')
  end

  def complite(discontent)
    post = discontent.concept_post_discontents.by_concept(self).first
    post.complite if post
  end

  def note_size?(type_fd)
    self.post_notes(type_fd).size > 0
  end

  def update_status_fields(pa)
    if read_attribute('name') != pa['name']
      self.status_name = nil
    end
    if read_attribute('content') != pa['content']
      self.status_content = nil
    end
    if read_attribute('negative') != pa['negative']
      self.status_negative = nil
    end
    if read_attribute('positive') != pa['positive']
      self.status_positive = nil
    end
    if read_attribute('control') != pa['control']
      self.status_control = nil
    end
    if read_attribute('obstacles') != pa['obstacles']
      self.status_obstacles = nil
    end
    if read_attribute('reality') != pa['reality']
      self.status_reality = nil
    end
    if read_attribute('problems') != pa['problems']
      self.status_problems = nil
    end
  end

  def fullness_apply(post_aspect, resor)
    if post_aspect.title.present? and post_aspect.name.present? and post_aspect.content.present?
      self.fullness = 40
    end
    if post_aspect.positive.present? and resor.any? { |r| r[:type_res] == 'positive_r' and r[:name]!='' }
      self.fullness += 30
    end
    if post_aspect.negative.present? and resor.any? { |r| r[:type_res] == 'negative_r' and r[:name]!='' }
      self.fullness += 20
    end
    if post_aspect.control.present? and resor.any? { |r| r[:type_res] == 'control_r' and r[:name]!='' }
      self.fullness += 10
    end
    if post_aspect.obstacles.present? and post_aspect.reality.present? and post_aspect.problems.present?
      self.fullness += 10
    end
  end

  def fullness_title
    new_fullness = 0
    if fullness.present?
      if status_name and status_content
        new_fullness += 40
      end
      if status_positive and status_positive_r
        new_fullness += 30
      end
      if status_negative and status_negative_r
        new_fullness += 20
      end
      if status_control and status_control_r
        new_fullness += 10
      end
      if status_obstacles and status_problems and status_reality
        new_fullness += 10
      end
    end
    new_fullness
  end

  def update_statuses
    statuses = []
    if name.present?
      self.status_name = true
      statuses << 'name'
    end
    if content.present?
      self.status_content = true
      statuses << 'content'
    end
    if positive.present?
      self.status_positive = true
      statuses << 'positive'
    end
    if negative.present?
      self.status_negative = true
      statuses << 'negative'
    end
    if control.present?
      self.status_control = true
      statuses << 'control'
    end
    if obstacles.present?
      self.status_obstacles = true
      statuses << 'obstacles'
    end
    if reality.present?
      self.status_reality = true
      statuses << 'reality'
    end
    if problems.present?
      self.status_problems = true
      statuses << 'problems'
    end
    if self.concept_post_resources.by_type('positive_r').present?
      self.status_positive_r = true
      statuses << 'positive_r'
    end
    if self.concept_post_resources.by_type('negative_r').present?
      self.status_negative_r = true
      statuses << 'negative_r'
    end
    if self.concept_post_resources.by_type('control_r').present?
      self.status_control_r = true
      statuses << 'control_r'
    end
    statuses
  end
end
