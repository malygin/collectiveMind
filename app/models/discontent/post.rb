class Discontent::Post < ActiveRecord::Base
  include PgSearch
  include BasePost

  belongs_to :aspect
  belongs_to :discontent_post, foreign_key: 'discontent_post_id', class_name: 'Discontent::Post'

  has_many :discontent_posts, class_name: 'Discontent::Post', foreign_key: 'discontent_post_id'
  has_many :discontent_post_aspects, class_name: 'Discontent::PostAspect'
  has_many :post_aspects, through: :discontent_post_aspects, source: :core_aspect, class_name: 'Core::Aspect'
  has_many :concept_post_discontents, -> { where concept_post_discontents: {status: [0, nil]} },
           class_name: 'Concept::PostDiscontent', foreign_key: 'discontent_post_id'
  has_many :dispost_concepts, through: :concept_post_discontents, source: :post, class_name: 'Concept::Post'
  has_many :plan_conditions, class_name: 'Plan::PostAspect', foreign_key: 'core_aspect_id'
  has_many :concept_posts, through: :concept_conditions, foreign_key: 'concept_post_id', class_name: 'Concept::Post'
  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'discontent_post_id', class_name: 'Discontent::Voting'
  has_many :concept_votings, foreign_key: 'discontent_post_id', class_name: 'Concept::Voting'
  has_many :concept_post_discontent_grouped, -> { where concept_post_discontents: {status: [1]} },
           class_name: 'Concept::PostDiscontent', foreign_key: 'discontent_post_id'
  has_many :advices, class_name: 'Advice', as: :adviseable

  validates :content, :whend, :whered, :project_id, presence: true

  scope :by_project, ->(p) { where(project_id: p) }
  scope :by_project_and_not_anonym, ->(p) { where(project_id: p, anonym: false) }
  scope :by_status, ->(p) { where(status: p) }
  scope :by_style, ->(p) { where(style: p) }
  scope :by_positive, ->(p) { where(style: 0, status: p) }
  scope :by_negative, ->(p) { where(style: 1, status: p) }
  scope :for_union, ->(project) { where('discontent_posts.status = 0 and discontent_posts.project_id = ? ', project) }
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
  scope :type_note, -> (type_note) { joins(:notes) if type_note.present? and type_note != 'content_all' }
  scope :type_like, -> type_like { where(useful: type_like == 'by_like' ? 't' : ['f', nil]) if type_like.present? and type_like != 'content_all' }
  scope :type_verify, -> type_verify { type_verify == 'by_verified' ? by_verified : by_unverified if type_verify.present? and type_verify != 'content_all' }
  scope :sort_date, -> sort_date { sort_date == 'up' ? order('discontent_posts.created_at DESC') : order('discontent_posts.created_at ASC') if sort_date.present? }
  scope :sort_user, -> sort_user { sort_user == 'up' ? order('discontent_posts.user_id DESC') : order('discontent_posts.user_id ASC') if sort_user.present? }
  scope :sort_view, -> sort_view { sort_view == 'up' ? order('discontent_posts.number_views DESC') : order('discontent_posts.number_views ASC') if sort_view.present? }
  pg_search_scope :autocomplete_whend,
                  against: [:whend],
                  using: {
                      tsearch: {prefix: true}
                  }
  pg_search_scope :autocomplete_whered,
                  against: [:whered],
                  using: {
                      tsearch: {prefix: true}
                  }

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
    union_posts = self.discontent_posts.where('discontent_posts.id <> ?', ungroup_post.id)
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
    post_all = dispost_concepts.by_status(0).size - 1
    concept_posts = dispost_concepts.by_status(0).order('concept_posts.id')
    if last_vote.nil? or id != last_vote.discontent_post_id
      concept1 = concept_posts[0].post_aspects.first
      concept2 = concept_posts[1].post_aspects.first
      votes = 1
    else
      concept1 = last_vote.concept_post_aspect
      count_now = current_user.concept_post_votings.by_project_votings(project).where(discontent_post_id: id, concept_post_aspect_id: concept1.id).count
      concept2 = concept_posts[count_now + 1].post_aspects.first unless concept_posts[count_now + 1].nil?
      votes = count_now == post_all ? count_now : count_now + 1
    end
    return post_all, concept1, concept2, votes
  end
end
