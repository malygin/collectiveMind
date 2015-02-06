class Discontent::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :whend, :whered, :aspect_id, :aspect, :style, :anonym, :discontent_post_id, :important, :status_content, :status_whered, :status_whend, :improve_comment, :improve_stage, :discuss_status

  belongs_to :aspect
  belongs_to :discontent_post, foreign_key: 'discontent_post_id', class_name: 'Discontent::Post'

  has_many :discontent_posts, class_name: 'Discontent::Post', foreign_key: 'discontent_post_id'
  has_many :discontent_post_aspects, class_name: 'Discontent::PostAspect'
  has_many :post_aspects, through: :discontent_post_aspects, source: :discontent_aspect, class_name: 'Discontent::Aspect'
  has_many :concept_post_discontents, -> { where concept_post_discontents: {status: [0, nil]} }, class_name: 'Concept::PostDiscontent', foreign_key: 'discontent_post_id'
  has_many :dispost_concepts, through: :concept_post_discontents, source: :post, class_name: 'Concept::Post'
  has_many :concept_conditions, class_name: 'Concept::PostAspect', foreign_key: 'discontent_aspect_id'
  has_many :plan_conditions, class_name: 'Plan::PostAspect', foreign_key: 'discontent_aspect_id'
  has_many :concept_posts, through: :concept_conditions, foreign_key: 'concept_post_id', class_name: 'Concept::Post'
  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'discontent_post_id', class_name: 'Discontent::Voting'
  has_many :concept_votings, foreign_key: 'discontent_post_id', class_name: 'Concept::Voting'
  has_many :concept_post_discontent_grouped, -> { where concept_post_discontents: {status: [1]} }, class_name: 'Concept::PostDiscontent', foreign_key: 'discontent_post_id'
  has_many :advices, class_name: 'Advice', as: :adviseable

  scope :by_project, ->(p) { where(project_id: p) }
  scope :by_project_and_not_anonym, ->(p) { where(project_id: p, anonym: false) }
  scope :by_status, ->(p) { where(status: p) }
  scope :by_style, ->(p) { where(style: p) }
  scope :by_positive, ->(p) { where(style: 0, status: p) }
  scope :by_negative, ->(p) { where(style: 1, status: p) }

  # @todo кандидаты на удаление, нигде не используется?
  # has_many :discontent_post_discussions, class_name: 'Discontent::PostDiscussion'
  # has_many :concept_post_discussions, class_name: 'Concept::PostDiscussion'
  # has_many :discontent_notes, class_name: 'Discontent::Note'
  # has_many :post_replaced, through: :post_replaces, source: :replace_post, class_name: 'Discontent::Post'
  # has_many :post_replaced_it, through: :post_it_replaces, source: :replace_post, class_name: 'Discontent::Post'
  # has_many :dispost_discussion_users, through: :discontent_post_discussions, source: :user, class_name: 'User'
  # has_many :dispost_discussion_users, through: :concept_post_discussions, source: :user, class_name: 'User'
  # scope :by_positive_vote, ->(p) { where(style: 0).where("status IN (#{p.join(", ")})", p) }
  # scope :by_negative_vote, ->(p) { where(style: 1).where("status IN (#{p.join(", ")})", p) }
  # scope :required_posts, ->(p) { where(status: 4, project_id: p.id) }
  # scope :by_discussions, ->(posts) { where("discontent_posts.id NOT IN (#{posts.join(", ")})") unless posts.empty? }
  # scope :not_view, ->(posts) { where("discontent_posts.id NOT IN (#{posts.join(", ")})") unless posts.empty? }
  # scope :posts_for_discussions, ->(p) { where(project_id: p.id).where("discontent_posts.status_content = 't' and discontent_posts.status_whered = 't' and discontent_posts.status_whend = 't'") }
  # scope :sort_comment, -> sort_comment { sort_comment == "up" ? includes(:comments).group('"discontent_posts"."id"').references(:comments).select('count("discontent_comments"."id")').order('count("discontent_comments"."id") DESC NULLS LAST') : includes(:comments).group('"discontent_posts"."id"').references(:comments).select('count("discontent_comments"."id") as count').order('count("discontent_comments"."id") ASC NULLS LAST') if sort_comment.present? }

  scope :united_for_vote, ->(project, voted) { where(project_id: project, status: [2,4]).where.not(id: voted).order(:id) }
  scope :for_union, ->(project) { where("discontent_posts.status = 0 and discontent_posts.project_id = ? ", project) }

  scope :by_status_for_discontent, ->(project) {
    if project.status == 4
      where(status: [0, 1])
    elsif project.status == 5 or project.status == 6
      where(status: [2, 4])
    elsif project.status > 6
      where(status: 1)
    else
      where(status: 0)
    end
  }
  scope :by_verified, -> { where(discontent_posts: {status_content: 't', status_whered: 't', status_whend: 't'}) }
  scope :by_unverified, -> { where(discontent_posts: {status_content: ['f', nil], status_whered: ['f', nil], status_whend: ['f', nil]}) }

  scope :type_note, -> type_note { joins(:notes) if type_note.present? and type_note != "content_all" }
  scope :type_like, -> type_like { where(:useful => type_like == "by_like" ? 't' : ['f', nil]) if type_like.present? and type_like != "content_all" }
  scope :type_verify, -> type_verify { type_verify == "by_verified" ? by_verified : by_unverified if type_verify.present? and type_verify != "content_all" }
  scope :type_status, -> type_status {
    if type_status.present? and type_status != "content_all"
      if type_status == "by_discuss"
        where(:discuss_status => true)
      elsif type_status == "by_approve"
        where(:approve_status => true)
      end
    end
  }

  scope :sort_date, -> sort_date { sort_date == "up" ? order('discontent_posts.created_at DESC') : order('discontent_posts.created_at ASC') if sort_date.present? }
  scope :sort_user, -> sort_user { sort_user == "up" ? order('discontent_posts.user_id DESC') : order('discontent_posts.user_id ASC') if sort_user.present? }
  scope :sort_view, -> sort_view { sort_view == "up" ? order('discontent_posts.number_views DESC') : order('discontent_posts.number_views ASC') if sort_view.present? }

  validates :content, :whend, :whered, :project_id, presence: true

  def complite(concept)
    post = self.concept_post_discontents.by_concept(concept.id).first
    post.complite if post
  end

  def update_post_aspects(aspects_new)
    self.discontent_post_aspects.destroy_all
    aspects_new.each do |asp|
      aspect = Discontent::PostAspect.create(post_id: self.id, aspect_id: asp.to_i)
      aspect.save!
    end
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

  def destroy_ungroup_aspects(ungroup_post)
    aspects_for_ungroup = ungroup_post.post_aspects.pluck(:id)
    union_posts = self.discontent_posts.where("discontent_posts.id <> ?", ungroup_post.id)
    union_posts_aspects = []
    if union_posts.present?
      union_posts.each do |p|
        union_posts_aspects = union_posts_aspects | p.post_aspects.pluck(:id) if p.post_aspects.present?
      end
    end

    if aspects_for_ungroup.present? and union_posts_aspects.present?
      aspects_for_ungroup.each do |asp|
        unless union_posts_aspects.include? asp
          self.discontent_post_aspects.by_aspect(asp).destroy_all
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

  def voted(user)
    self.voted_users.where(id: user)
  end

  # @todo кандидат на удаление, нигде не используется
  #def post_notes(type_field)
  #  self.discontent_notes.by_type(type_field)
  #end

  # @todo кандидат на удаление, нигде не используется
  # def get_posts_suitable_for_association
  #   aspects = self.post_aspects.pluck(:id)
  #
  #   Discontent::Post.includes(:discontent_post_aspects).where(discontent_post_aspects: {aspect_id: aspects}).where("discontent_posts.status = 0 and discontent_posts.id <> ? and (discontent_posts.whered = ? or discontent_posts.whend = ?)", self.id, self.whered, self.whend)
  # end

  # @todo кандидат на удаление, нигде не используется
  # def get_posts_for_union_add_list(project)
  #   aspects = self.post_aspects.pluck(:id)
  #
  #   posts = Discontent::Post.joins(:discontent_post_aspects).where(discontent_post_aspects: {aspect_id: aspects}).where("discontent_posts.status = 0 and discontent_posts.project_id = ? and (discontent_posts.whered = ? or discontent_posts.whend = ?)", project.id, self.whered, self.whend).pluck(:id)
  #   Discontent::Post.where("discontent_posts.status = 0 and discontent_posts.project_id = ?", project.id).not_view(posts)
  # end

  # @todo кандидат на удаление, нигде не используется
  # def conditions_for_plan(plan)
  #   plan_conditions.where(plan_post_id: plan)
  # end

  # @todo кандидат на удаление, нигде не используется
  # def pure_conditions
  #   concept_conditions.where("concept_post_id IS NOT NULL")
  # end

  def show_content
    unless self.content.nil?
      '<b> что: </b>' + self.content +
          (self.whered.present? ? '<br/> <b> где: </b> ' + self.whered : '') +
          (self.whend.present? ? '<br/> <b> когда: </b>' + self.whend : '') +
          '<br/>'
    end
  end

  def display_content
    discontent_posts.first.content if status == 4 and !discontent_posts.empty?
  end

  def not_vote_for_other_post_aspects(user)
    self.concept_conditions.each do |asp|
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

  def concepts_for_vote(project, current_user, last_vote)
    @post_all = self.dispost_concepts.by_status(0).size - 1
    concept_posts = self.dispost_concepts.by_status(0).order('concept_posts.id')
    if last_vote.nil? or self.id != last_vote.discontent_post_id
      @concept1 = concept_posts[0].post_aspects.first
      @concept2 = concept_posts[1].post_aspects.first
      @votes = 1
    else
      @concept1 = last_vote.concept_post_aspect
      count_now = current_user.concept_post_votings.by_project_votings(project).where(discontent_post_id: self.id, concept_post_aspect_id: @concept1.id).count
      @concept2 = concept_posts[count_now+1].post_aspects.first unless concept_posts[count_now+1].nil?
      @votes = count_now == @post_all ? count_now : count_now + 1
    end
    return @post_all, @concept1, @concept2, @votes
  end

  def self.united_for_vote_new(project, voted)
    all_posts = self.where(project_id: project, status: [2,4]).where.not(id: voted).includes(:post_aspects).order("discontent_aspects.id")
    one_posts = []
    many_posts = []
    all_posts.each do |post|
      if post.post_aspects.size == 1
        one_posts << post
      else
        many_posts << post
      end
    end
    one_posts | many_posts
  end
end
