 class Concept::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :goal, :reality,
                  :stat_name, :stat_content, :stat_negative, :stat_positive, :stat_reality, :stat_problems, :stat_positive_r, :stat_negative_r

  belongs_to :life_tape_post,  :class_name => "LifeTape::Post"
  has_many :task_supply_pairs
  has_many :post_aspects, :foreign_key => 'concept_post_id', :class_name => "Concept::PostAspect"

  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings,:foreign_key => 'concept_post_aspect_id', :class_name => "Concept::Voting"

  has_many :concept_notes, :class_name => 'Concept::Note'

  has_many :concept_post_discontents, :class_name => 'Concept::PostDiscontent'
  has_many :concept_disposts, :through => :concept_post_discontents, :source => :discontent_post , :class_name => 'Discontent::Post'
  has_many :concept_post_resources, :class_name => 'Concept::PostResource'
  scope :stat_fields_negative, ->(p){where(:id => p).where("stat_name = 'f' or stat_content = 'f' or stat_negative = 'f'
            or stat_positive = 'f' or stat_reality = 'f' or stat_problems = 'f'
            or stat_positive_r = 'f' or stat_negative_r = 'f' ")}
  scope :stat_fields_positive, ->(p){where(:id => p).where("stat_name = 't' and stat_content = 't' and stat_negative = 't'
            and stat_positive = 't' and stat_reality = 't' and stat_problems = 't'
            and stat_positive_r = 't' and stat_negative_r = 't' ")}

  def self.scope_vote_top(post)
    joins(:concept_post_discontents).
    where('"concept_post_discontents"."discontent_post_id" = ?', post.id).
    joins(:post_aspects).
    joins('INNER JOIN "concept_votings" ON "concept_votings"."concept_post_aspect_id" = "concept_post_aspects"."id"').
    where('"concept_votings"."discontent_post_id" = "concept_post_aspects"."discontent_aspect_id"')
    .group('"concept_posts"."id"')
    .order('count("concept_votings"."user_id") DESC')
  end

  def post_notes(type_field)
    self.concept_notes.by_type(type_field)
  end

  def note_size?(type_fd)
    self.post_notes(type_fd).size > 0
  end

  def content
     self.post_aspects.first.content
  end

  def resource

  end

  def update_status_fields(pa,resor,res)
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
      if self.post_aspects.first.read_attribute('negative_r') != pa["#{aspect}"]['negative_r']
        self.stat_negative_r = nil
      end
    end

    resources = self.concept_post_resources.pluck(:name) unless self.concept_post_resources.nil?
    desc = self.concept_post_resources.pluck(:desc) unless self.concept_post_resources.nil?

    unless resources == resor and desc == res
      self.stat_positive_r = nil
    end
  end
end
