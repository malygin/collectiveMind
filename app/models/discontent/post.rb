# encoding: utf-8

class Discontent::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :whend, :whered, :aspect_id, :replace_id, :aspect, :style, :discontent_post_id, :important, :status_content, :status_whered, :status_whend
  belongs_to :aspect
  #has_many :childs, :class_name => 'Discontent::Post', :foreign_key => 'replace_id'
  #belongs_to :post, :class_name => 'Discontent::Post', :foreign_key => 'replace_id'
  belongs_to :discontent_post
  has_many :discontent_posts, :class_name => 'Discontent::Post', :foreign_key => 'discontent_post_id'
  has_many :discontent_notes, :class_name => 'Discontent::Note'

  has_many :discontent_post_aspects, :class_name => 'Discontent::PostAspect'
  has_many :post_aspects, :through => :discontent_post_aspects, :source => :discontent_aspect, :class_name => 'Discontent::Aspect'

  has_many :concept_post_discontents, :class_name => 'Concept::PostDiscontent', :foreign_key => 'discontent_post_id'
  has_many :dispost_concepts, :through => :concept_post_discontents, :source => :post, :class_name => "Concept::Post"

  has_many :concept_conditions, :class_name => 'Concept::PostAspect', :foreign_key => 'discontent_aspect_id'

  has_many :discontent_post_discussions, :class_name => 'Discontent::PostDiscussion'
  has_many :dispost_discussion_users, :through => :discontent_post_discussions, :source => :user, :class_name => 'User'

  has_many :concept_post_discussions, :class_name => 'Concept::PostDiscussion'
  has_many :dispost_discussion_users, :through => :concept_post_discussions, :source => :user, :class_name => 'User'

  has_many :plan_conditions, :class_name => 'Plan::PostAspect', :foreign_key => 'discontent_aspect_id'

  has_many :concept_posts, :through => :concept_conditions, :foreign_key => 'concept_post_id', :class_name => "Concept::Post"
  #has_many :post_replaces, :class_name => 'Discontent::PostReplace', :foreign_key => 'post_id'
  #has_many :post_it_replaces, :class_name => 'Discontent::PostReplace', :foreign_key => 'replace_id'

  has_many :post_replaced, :through => :post_replaces, :source => :replace_post, :class_name =>  'Discontent::Post'

  has_many :post_replaced_it, :through => :post_it_replaces, :source => :replace_post, :class_name =>  'Discontent::Post'

  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings,:foreign_key => 'discontent_post_id', :class_name => 'Discontent::Voting'

  has_many :concept_votings, :foreign_key => 'discontent_post_id', :class_name => 'Concept::Voting'
  scope :by_status, ->(p){where(status: p)}
  scope :by_positive, ->(p){where(style: 0, status: p)}
  scope :by_negative, ->(p){where(style: 1, status: p)}
  scope :required_posts, ->(p){where(status:4, project_id:p.id)}
  scope :united_for_vote,  ->(project,voted){where(project_id: project, status: 2).where("discontent_posts.id NOT IN (?)", voted<<0).order(:id)}

  scope :for_union, ->(project){ where("discontent_posts.status = 0 and discontent_posts.project_id = ? ", project) }

  scope :posts_for_discussions, ->(p){where(:project_id => p.id, status: 0).where("discontent_posts.status_content = 't' and discontent_posts.status_whered = 't' and discontent_posts.status_whend = 't'")}

  scope :by_discussions, ->(posts) { where("discontent_posts.id NOT IN (#{posts.join(", ")})") unless posts.empty? }

  #scope :uniquely_whend, :select => 'distinct whend'
  #scope :uniquely_whered, :select => 'distinct whered'
  #scope :ready_for_post, lambda {  where(:status => 0).where("created_at < ?", 2.day.ago) }
  #scope :not_ready_for_post, lambda {  where(:status => 0).where("created_at > ?", 2.day.ago) }

  def update_post_aspects(aspects_new)
    self.discontent_post_aspects.destroy_all
    aspects_new.each do |asp|
      aspect = Discontent::PostAspect.create(post_id: self.id, aspect_id: asp.to_i)
      aspect.save!
    end
    #aspects_old = self.discontent_post_aspects
    #unless aspects_old.nil? or aspects_new.nil?
    #  aspects_old.each do |asp|
    #    unless aspects_new.include? asp.aspect_id.to_s
    #      asp.destroy
    #    end
    #  end
    #end
    #aspects_old = self.post_aspects.nil? ? [] : self.post_aspects.pluck(:id)
    #unless aspects_new.nil?
    #  aspects_new.each do |asp|
    #    unless aspects_old.include? asp.to_i
    #      aspect = Discontent::PostAspect.create(post_id: self.id, aspect_id: asp.to_i)
    #      aspect.save!
    #    end
    #  end
    #end
  end

  def update_union_post_aspects(aspects_new)
    aspects_old = self.post_aspects.nil? ? [] : self.post_aspects.pluck(:id)
    unless aspects_new.nil?
      aspects_new.uniq.each do |asp|
        unless aspects_old.include? asp.id
          aspect = Discontent::PostAspect.create(post_id: self.id, aspect_id: asp.id)
          aspect.save!
        end
      end
    end
  end

  def update_status_fields(pa)
    if self.read_attribute('content') != pa['content']
      self.status_content = nil
    end
    if self.read_attribute('whend') != pa['whend']
      self.status_whend = nil
    end
    if self.read_attribute('whered') != pa['whered']
      self.status_whered = nil
    end
  end

  def post_notes(type_field)
    self.discontent_notes.by_type(type_field)
  end

  def voted(user)
    self.voted_users.where(:id => user)
  end

  def get_posts_suitable_for_association
    #Discontent::Post.where(status: 0, style: self.style).where('id!=?', self.id).where('whered = ? or whend = ?',self.whered, self.whend)
    aspects = self.post_aspects.pluck(:id)

    Discontent::Post.includes(:discontent_post_aspects).
    where("discontent_post_aspects.aspect_id IN (#{aspects.join(', ')}) and discontent_posts.status = 0 and discontent_posts.id <> ?
    and (discontent_posts.whered = ? or discontent_posts.whend = ?)", self.id, self.whered, self.whend)
  end

  def conditions_for_plan(plan)
    plan_conditions.where(:plan_post_id => plan)
  end

  def pure_conditions()
    concept_conditions.where("concept_post_id IS NOT NULL")
  end

  def show_content
    unless self.content.nil?
      '<b> что: </b>' + self.content +
      (self.whered.present? ? '<br/> <b> где: </b> ' + self.whered : '') +
      (self.whend.present? ? '<br/> <b> когда: </b>' + self.whend : '') +
      '<br/>'
    end
  end

  def display_content
    discontent_posts.first.content if status == 4 and  !discontent_posts.empty?
  end

  #def content
  #  '123123' if content.nil?
  #end

  def not_vote_for_other_post_aspects(user)
    self.concept_conditions.each  do |asp|
      if asp.voted(user).size>0
        return false
      end
    end
    true
  end

  def one_last_post?
    discontent_posts.size < 2
  end

  def note_size?(type_fd)
    self.post_notes(type_fd).size > 0
  end

end
