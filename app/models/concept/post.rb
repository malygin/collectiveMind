class Concept::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :goal, :reality, :fullness,
                  :status_name, :status_content, :status_negative, :status_positive, :status_reality, :status_problems, :status_positive_r, :status_negative_r, :discuss_status,
                  :status_positive_s, :status_negative_s, :status_control, :status_control_r, :status_control_s, :status_obstacles

  belongs_to :life_tape_post, class_name: 'LifeTape::Post'

  # @todo кандидат на удаление
  #has_many :task_supply_pairs
  #has_many :concept_notes, class_name: 'Concept::Note'
  has_many :post_aspects, foreign_key: 'concept_post_id', class_name: 'Concept::PostAspect'
  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'concept_post_aspect_id', class_name: 'Concept::Voting'

  has_many :concept_post_discontents, -> { where concept_post_discontents: {status: [0, nil]} }, class_name: 'Concept::PostDiscontent'
  has_many :concept_disposts, through: :concept_post_discontents, source: :discontent_post, class_name: 'Discontent::Post'
  has_many :concept_post_resources, class_name: 'Concept::PostResource'
  has_many :concept_post_discontent_grouped, -> { where concept_post_discontents: {status: [1]} }, class_name: 'Concept::PostDiscontent'
  has_many :advices, class_name: 'Advice', as: :adviseable

  scope :stat_fields_negative, ->(p) { where(id: p).where("status_name = 'f' or status_content = 'f' or status_negative = 'f'
            or status_positive = 'f' or status_control = 'f' or status_obstacles = 'f' or status_reality = 'f' or status_problems = 'f' ") }
  scope :stat_fields_positive, ->(p) { where(id: p).where("status_name = 't' and status_content = 't' and status_negative = 't'
            and status_positive = 't' and status_control = 't' and status_obstacles = 't' and status_reality = 't' and status_problems = 't' ") }
  scope :by_status, ->(p) { where(status: p) }
  scope :by_project, ->(p) { where(project_id: p) }
  scope :by_discussions, ->(posts) { where("concept_posts.id NOT IN (#{posts.join(', ')})") unless posts.empty? }
  scope :posts_for_discussions, ->(p) { where(project_id: p.id, status: 0).where("concept_posts.status_name = 't' and concept_posts.status_content = 't'") }
  scope :by_idea, -> { where(fullness: [0, nil]) }
  scope :by_novation, -> { where("concept_posts.fullness > 0") }

  def self.scope_vote_top(post)
    joins(:concept_post_discontents).
        where('"concept_post_discontents"."discontent_post_id" = ?', post.id).
        joins(:post_aspects).
        joins('INNER JOIN "concept_votings" ON "concept_votings"."concept_post_aspect_id" = "concept_post_aspects"."id"').
        where('"concept_votings"."discontent_post_id" = "concept_post_aspects"."discontent_aspect_id"')
        .group('"concept_posts"."id"')
        .order('count("concept_votings"."user_id") DESC')
  end


  # @todo кандидаты на удаление
  # scope :date_stage, ->(project) { where("DATE(concept_posts.created_at) >= ? AND DATE(concept_posts.created_at) <= ?", project.date_23.to_date, project.date_34.to_date) if project.date_23.present? and project.date_34.present? }
  #def post_notes(type_field)
  #  self.concept_notes.by_type(type_field)
  #end
  # def get_status_concept?(status)
  #   if status == 'positive'
  #     self.status_name and self.status_content and self.status_negative and self.status_negative_r and self.status_positive and self.status_positive_r and self.status_control and self.status_control_r and self.status_obstacles and self.status_reality and self.status_problems
  #   elsif status == 'negative'
  #     self.status_name.nil? and self.status_content.nil? and self.status_negative.nil? and self.status_negative_r.nil? and self.status_positive.nil? and self.status_positive_r.nil? and self.status_control.nil? and self.status_control_r.nil? and self.status_obstacles.nil? and self.status_reality.nil? and self.status_problems.nil?
  #   end
  # end
  #
  # def resource
  #
  # end

  def complite(discontent)
    post = discontent.concept_post_discontents.by_concept(self.id).first
    post.complite if post
  end

  def note_size?(type_fd)
    self.post_notes(type_fd).size > 0
  end

  def content
    self.post_aspects.first.content
  end

  def dispost
    self.post_aspects.first.discontent_aspect_id
  end

  def update_status_fields(pa)
    if self.post_aspects.first
      if self.post_aspects.first.read_attribute('name') != pa['name']
        self.status_name = nil
      end
      if self.post_aspects.first.read_attribute('content') != pa['content']
        self.status_content = nil
      end
      if self.post_aspects.first.read_attribute('negative') != pa['negative']
        self.status_negative = nil
      end
      if self.post_aspects.first.read_attribute('positive') != pa['positive']
        self.status_positive = nil
      end
      if self.post_aspects.first.read_attribute('control') != pa['control']
        self.status_control = nil
      end
      if self.post_aspects.first.read_attribute('obstacles') != pa['obstacles']
        self.status_obstacles = nil
      end
      if self.post_aspects.first.read_attribute('reality') != pa['reality']
        self.status_reality = nil
      end
      if self.post_aspects.first.read_attribute('problems') != pa['problems']
        self.status_problems = nil
      end
    end
  end

  def fullness_apply(post_aspect, resor)
    if post_aspect.title.present? and post_aspect.name.present? and post_aspect.content.present?
      self.fullness = 40
    end
    # if post_aspect.positive.present? or post_aspect.negative.present? or post_aspect.control.present? or post_aspect.obstacles.present? or post_aspect.reality.present? or post_aspect.problems.present? or resor.any? { |r| r[:name]!='' }
    #   self.fullness = 1
    # end
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
    fullness = 0
    if self.fullness.present?
      if self.status_name and self.status_content
        fullness+=40
      end
      if self.status_positive and self.status_positive_r
        fullness+=30
      end
      if self.status_negative and self.status_negative_r
        fullness+=20
      end
      if self.status_control and self.status_control_r
        fullness+=10
      end
      if self.status_obstacles and self.status_problems and self.status_reality
        fullness+=10
      end
    end
    fullness
  end

  def update_statuses
    post_aspect = self.post_aspects.first
    statuses = []
    if post_aspect
      if post_aspect.name.present?
        self.status_name = true
        statuses << 'name'
      end
      if post_aspect.content.present?
        self.status_content = true
        statuses << 'content'
      end
      if post_aspect.positive.present?
        self.status_positive = true
        statuses << 'positive'
      end
      if post_aspect.negative.present?
        self.status_negative = true
        statuses << 'negative'
      end
      if post_aspect.control.present?
        self.status_control = true
        statuses << 'control'
      end
      if post_aspect.obstacles.present?
        self.status_obstacles = true
        statuses << 'obstacles'
      end
      if post_aspect.reality.present?
        self.status_reality = true
        statuses << 'reality'
      end
      if post_aspect.problems.present?
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
    end
    statuses
  end
end
