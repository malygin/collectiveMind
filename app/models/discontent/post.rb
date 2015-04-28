class Discontent::Post < ActiveRecord::Base
  include PgSearch
  include BasePost

  belongs_to :discontent_post, foreign_key: 'discontent_post_id', class_name: 'Discontent::Post'
  # has_many :discontent_posts, class_name: 'Discontent::Post', foreign_key: 'discontent_post_id'

  has_many :discontent_post_aspects, class_name: 'Discontent::PostAspect'
  has_many :post_aspects, through: :discontent_post_aspects, source: :core_aspect, class_name: 'Core::Aspect::Post'

  #галочки для выбранных несовершенств группы в нововведении
  has_many :concept_post_discontent_checks, -> { where concept_post_discontents: {status: [1]} },
           class_name: 'Concept::PostDiscontent', foreign_key: 'discontent_post_id'
  has_many :concept_post_discontents, -> { where concept_post_discontents: {status: [0, nil]} },
           class_name: 'Concept::PostDiscontent', foreign_key: 'discontent_post_id'
  has_many :dispost_concepts, through: :concept_post_discontents, source: :post, class_name: 'Concept::Post'

  has_many :final_votings, foreign_key: 'discontent_post_id', class_name: 'Discontent::Voting'
  has_many :voted_users, through: :final_votings, source: :user
  # has_many :concept_votings, foreign_key: 'discontent_post_id', class_name: 'Concept::Voting'

  has_many :advices, class_name: 'Advice', as: :adviseable

  validates :content, :whend, :whered, :project_id, presence: true

  default_scope { order :id }
  #@deprecated нужно использовать for_project из BasePost
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
      where(status: [0, 1, 2, 4]) # вывод всех
    else
      where(status: 0)
    end
  }

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
    post = self.concept_post_discontents.by_concept(concept).first
    post.complite if post
  end

  #привязка аспектов к несовершенству
  def update_post_aspects(aspects_new)
    discontent_post_aspects.destroy_all
    aspects_new.each do |asp|
      discontent_post_aspects.create(aspect_id: asp.to_i)
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

  def note_size?(type_fd)
    self.post_notes(type_fd).size > 0
  end

  def concepts_for_vote(project, current_user, last_vote)
    post_all = dispost_concepts.by_status(0).size - 1
    concept_posts = dispost_concepts.by_status(0).order('concept_posts.id')
    if last_vote.nil? or id != last_vote.discontent_post_id
      concept1 = concept_posts[0]
      concept2 = concept_posts[1]
      votes = 1
    else
      concept1 = last_vote.concept_post_aspect
      count_now = current_user.concept_post_votings.by_project_votings(project).where(discontent_post_id: id, concept_post_aspect_id: concept1.id).count
      concept2 = concept_posts[count_now + 1] unless concept_posts[count_now + 1].nil?
      votes = count_now == post_all ? count_now : count_now + 1
    end
    return post_all, concept1, concept2, votes
  end
end
