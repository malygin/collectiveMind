 class Concept::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :goal, :reality,
                  :status_name, :status_content, :status_negative, :status_positive, :status_reality, :status_problems, :status_positive_r, :status_negative_r, :discuss_status

  belongs_to :life_tape_post,  :class_name => "LifeTape::Post"
  has_many :task_supply_pairs
  has_many :post_aspects, :foreign_key => 'concept_post_id', :class_name => "Concept::PostAspect"

  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings,:foreign_key => 'concept_post_aspect_id', :class_name => "Concept::Voting"

  #has_many :concept_notes, :class_name => 'Concept::Note'

  has_many :concept_post_discontents, :class_name => 'Concept::PostDiscontent'
  has_many :concept_disposts, :through => :concept_post_discontents, :source => :discontent_post , :class_name => 'Discontent::Post'
  has_many :concept_post_resources, :class_name => 'Concept::PostResource'
  scope :stat_fields_negative, ->(p){where(:id => p).where("status_name = 'f' or status_content = 'f' or status_negative = 'f'
            or status_positive = 'f' or status_reality = 'f' or status_problems = 'f'
            or status_positive_r = 'f' or status_negative_r = 'f' ")}
  scope :stat_fields_positive, ->(p){where(:id => p).where("status_name = 't' and status_content = 't' and status_negative = 't'
            and status_positive = 't' and status_reality = 't' and status_problems = 't'
            and status_positive_r = 't' and status_negative_r = 't' ")}
  scope :by_status, ->(p){where(status: p)}

  scope :by_project, ->(p){ where(project_id: p) }

  scope :by_discussions, ->(posts) { where("concept_posts.id NOT IN (#{posts.join(", ")})") unless posts.empty? }

  scope :posts_for_discussions, ->(p){ where(:project_id => p.id, status: 0).where("concept_posts.status_name = 't' and concept_posts.status_content = 't'") }

  def self.scope_vote_top(post)
    joins(:concept_post_discontents).
    where('"concept_post_discontents"."discontent_post_id" = ?', post.id).
    joins(:post_aspects).
    joins('INNER JOIN "concept_votings" ON "concept_votings"."concept_post_aspect_id" = "concept_post_aspects"."id"').
    where('"concept_votings"."discontent_post_id" = "concept_post_aspects"."discontent_aspect_id"')
    .group('"concept_posts"."id"')
    .order('count("concept_votings"."user_id") DESC')
  end

  #def post_notes(type_field)
  #  self.concept_notes.by_type(type_field)
  #end

  def note_size?(type_fd)
    self.post_notes(type_fd).size > 0
  end

  def content
     self.post_aspects.first.content
  end

  def dispost
    self.post_aspects.first.discontent_aspect_id
  end

  def resource

  end

  def update_status_fields(pa,resor_pos,res_pos,resor_neg,res_neg)
    aspect = self.post_aspects.first.discontent_aspect_id
    unless aspect.nil?
      if self.post_aspects.first.read_attribute('name') != pa["#{aspect}"]['name']
        self.stat_name = nil
      end
      if self.post_aspects.first.read_attribute('content') != pa["#{aspect}"]['content']
        self.stat_content = nil
      end
      if self.post_aspects.first.read_attribute('negative') != pa["#{aspect}"]['negative']
        self.stat_negative = nil
      end
      if self.post_aspects.first.read_attribute('positive') != pa["#{aspect}"]['positive']
        self.stat_positive = nil
      end
      if self.post_aspects.first.read_attribute('reality') != pa["#{aspect}"]['reality']
        self.stat_reality = nil
      end
      if self.post_aspects.first.read_attribute('problems') != pa["#{aspect}"]['problems']
        self.stat_problems = nil
      end
    end

    resources_pos = self.concept_post_resources.by_type('positive_r').pluck(:name) unless self.concept_post_resources.by_type('positive_r').nil?
    desc_pos = self.concept_post_resources.by_type('positive_r').pluck(:desc) unless self.concept_post_resources.by_type('positive_r').nil?
    resources_neg = self.concept_post_resources.by_type('negative_r').pluck(:name) unless self.concept_post_resources.by_type('negative_r').nil?
    desc_neg = self.concept_post_resources.by_type('negative_r').pluck(:desc) unless self.concept_post_resources.by_type('negative_r').nil?

    unless resources_pos == resor_pos and desc_pos == res_pos
      self.stat_positive_r = nil
    end
    unless resources_neg == resor_neg and desc_neg == res_neg
      self.stat_negative_r = nil
    end
  end
end
