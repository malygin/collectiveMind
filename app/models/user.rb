class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include ApplicationHelper
  include MarkupHelper
  include PgSearch

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lastseenable
  attr_accessor :secret, :secret2, :secret3

  has_many :core_project_scores, class_name: 'Core::ProjectScore'
  has_many :help_posts, class_name: 'Core::Help::Post', through: :help_questions, source: :post
  has_many :journals
  has_many :discontent_posts, class_name: 'Discontent::Post'
  has_many :core_aspects, class_name: 'Core::Aspect::Post'
  has_many :essay_posts, class_name: 'Core::Essay::Post'
  has_many :concept_posts, class_name: 'Concept::Post'
  has_many :aspect_votings, class_name: 'CollectInfo::Voting'
  has_many :voted_aspects, through: :aspect_votings, source: :aspect, class_name: 'Core::Aspect::Post'

  has_many :post_votings, class_name: 'Discontent::Voting'
  has_many :voted_discontent_posts, through: :post_votings, source: :discontent_post, class_name: 'Discontent::Post'

  has_many :concept_post_votings, class_name: 'Concept::Voting'
  has_many :voted_concept_post, through: :concept_post_votings, source: :concept_post, class_name: 'Concept::Post'

  has_many :novation_posts, class_name: 'Novation::Post'
  has_many :novation_post_votings, class_name: 'Novation::Voting'
  has_many :voted_novation_post, through: :novation_post_votings, source: :novation_post, class_name: 'Novation::Post'

  has_many :plan_post_votings, class_name: 'Plan::Voting'
  has_many :voted_plan_posts, through: :plan_post_votings, source: :plan_post, class_name: 'Plan::Post'
  has_many :plan_posts, class_name: 'Plan::Post'

  has_many :core_project_users, class_name: 'Core::ProjectUser'
  has_many :projects, through: :core_project_users, source: :core_project, class_name: 'Core::Project'

  has_many :moderator_messages
  has_many :user_checks, class_name: 'UserCheck'
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :group_chat_messages
  scope :not_admins, -> { where 'users.type_user NOT IN (?) or users.type_user IS NULL', [1] }
  has_many :user_answers, class_name: 'CollectInfo::UserAnswers'
  has_many :news, class_name: 'News'
  has_many :loggers, class_name: 'JournalLogger'
  has_many :core_content_user_answers, :class_name => 'Core::ContentUserAnswer'
  default_scope { order('id DESC') }
  # scope :check_field, ->(p, c) { joins(:user_checks).where(user_checks: {project: p.id, status: 't', check_field: c}) }
  scope :without_added, ->(users) { where.not(id: users) unless users.empty? }

  validates :name, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}


  pg_search_scope :search,
                  against: [:name, :surname, :email],
                  using: {
                      tsearch: {prefix: true}
                  }


  def valid_password?(password)
    begin
      super(password)
    rescue BCrypt::Errors::InvalidHash
      return false unless password == encrypted_password
      logger.info "User #{email} is using the old password hashing method, updating attribute."
      self.password = password
      true
    end
  end

  def last_event(project)
    Journal.last_event_for(self, project)
  end

  def user_project_scores(project)
    self.core_project_scores.where('core_project_scores.project_id = ?', project).first
  end

  def to_s
    if self.anonym
      self.nickname
    else
      "#{self.name} #{self.surname}"
    end
  end

  def role_name
    if self.type_user == 1
      'модератор'
    else
      ''
    end
  end

  def boss?
    type_user == 1
  end

  def add_score(h={})
    case h[:type]
      when :plus_post
        self.add_score_by_type(h[:project], h[:score], h[:type_score])
        self.journals.build(type_event: 'my_add_score_'+h[:model_score], project: h[:project], user_informed: self, body: h[:score], first_id: h[:post].id, body2: trim_content(field_for_journal(h[:post])), viewed: false, personal: true).save!

      when :to_archive_plus_post
        self.add_score_by_type(h[:project], -h[:score], h[:type_score])
        Journal.destroy_journal_record(h[:project], 'my_add_score_'+h[:model_score], self, h[:post], true)

    end
  end

  def add_score_by_type(project, score, type = :collect_info_posts_score)
    ps = self.core_project_users.by_project(project).first_or_create
    ps.update_attributes!(score: score + (ps.score || 0), type => (ps.read_attribute(type) || 0) + score)
    # Award.reward(user: self, old_score: ps.score-score, project: project, score: ps.score, type: 'max')
    # self.user_project_scores(project).update_attributes!(score: score+self.score, type => self.read_attribute(type)+score)
  end

  def can_vote_for(stage, project)
    if stage == :collect_info and project.stage == '1:2' and project.get_free_votes_for(self, stage) > 0
      return true
    elsif stage == :discontent and project.stage == '2:1' and project.get_free_votes_for(self, stage) > 0
      return true
    elsif stage == :concept and project.stage == '3:1' and project.get_free_votes_for(self, stage) > 0
      return true
    elsif stage == :novation and project.stage == '4:1' and project.get_free_votes_for(self, stage) > 0
      return true
    end
    false
  end

  def my_journals(project)
    events = Journal.events_for_my_feed project.id, id
    g = events.group_by { |e| [e.first_id, e.type_event] }
    g.collect { |k, v| [v.first, v.size] }
  end

  def my_journals_viewed(project)
    events = Journal.events_for_my_feed_viewed project.id, id
    g = events.group_by { |e| [e.first_id, e.type_event] }
    g.collect { |k, v| [v.first, v.size] }
  end

  def looked_chat
    update_attributes! last_seen_chat_at: Time.now
  end

  def moderator_in_project?(project)
    project.project_users.by_type(1).include? self
  end


  def group_include_user?(user)
    groups.each do |group|
      return true if group.users.include?(user)
    end
    false
  end

  def project_user_for(project)
    core_project_users.find_by(project_id: project.id)
  end

  # аспекты для голосования (необходимые, важные, неважные)
  def aspects_for_vote(project, status)
    self.voted_aspects.by_project(project.id).where(collect_info_votings: {status: status})
  end

  # аспекты за которые пользователь еще не проголосовал
  def unvote_aspects_for_vote(project)
    vote_aspects = project.proc_main_aspects.joins(:final_votings).where(collect_info_votings: {user_id: self.id}).pluck('core_aspect_posts.id')
    project.proc_main_aspects.where.not(id: vote_aspects)
  end

  # несовершенства для голосования (необходимые, важные, неважные)
  def discontents_for_vote(project, status)
    self.voted_discontent_posts.by_project(project.id).where(discontent_votings: {status: status})
  end

  # несовершенства за которые пользователь еще не проголосовал
  def unvote_discontents_for_vote(project)
    vote_discontents = project.discontent_for_vote.joins(:final_votings).where(discontent_votings: {user_id: self.id}).pluck('discontent_posts.id')
    project.discontent_for_vote.where.not(id: vote_discontents)
  end

  # идеи для голосования (да, нет)
  def concepts_for_vote(project, status)
    self.voted_concept_post.by_project(project.id).where(concept_votings: {status: status})
  end

  # идеи за которые пользователь еще не проголосовал
  def unvote_concepts_for_vote(project)
    vote_concepts = project.concept_ongoing_post.joins(:final_votings).where(concept_votings: {user_id: self.id}).pluck('concept_posts.id')
    project.concept_ongoing_post.where.not(id: vote_concepts)
  end

  # пакеты для голосования (да, нет)
  def novations_for_vote(project, status)
    self.voted_novation_post.by_project(project.id).where(novation_votings: {status: status})
  end

  # пакеты за которые пользователь еще не проголосовал
  def unvote_novations_for_vote(project)
    vote_novations = project.novations_for_vote.joins(:final_votings).where(novation_votings: {user_id: self.id}).pluck('novation_posts.id')
    project.novations_for_vote.where.not(id: vote_novations)
  end

  def content_for_project(stage, project)
    if stage == :collect_info_posts
      core_aspects.by_project(project)
    else
      send(stage).for_project(project.id)
    end
  end

  def comment_for_project(stage, project)
    if stage == :collect_info_posts
      core_aspects.by_project(project).joins(:comments)
    else
      send(stage).by_project(project.id).joins(:comments)
    end
  end

  def plan_vote_status(post, type)
    self.plan_post_votings.by_post(post).by_type(type).first.try(:status) || 0
  end
end
