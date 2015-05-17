class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include ApplicationHelper
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
  has_many :core_project_users, class_name: 'Core::ProjectUser'
  has_many :projects, through: :core_project_users, source: :core_project, class_name: 'Core::Project'
  has_many :user_awards, class_name: 'Core::UserAward'
  has_many :awards, through: :user_awards
  has_many :moderator_messages
  has_many :user_checks, class_name: 'UserCheck'
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :group_chat_messages
  has_many :plan_posts, class_name: 'Plan::Post'
  has_many :user_answers, class_name: 'CollectInfo::UserAnswers'
  has_many :news, class_name: 'News'
  has_many :loggers, class_name: 'JournalLogger'
  has_many :core_content_user_answers, :class_name => 'Core::ContentUserAnswer'
  default_scope { order('id DESC') }
  # scope :check_field, ->(p, c) { joins(:user_checks).where(user_checks: {project: p.id, status: 't', check_field: c}) }
  scope :without_added, ->(users) { where.not(id: users) unless users.empty? }
  scope :not_admins, -> { where 'users.type_user NOT IN (?) or users.type_user IS NULL', TYPES_USER[:admin] }

  validates :name, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  TYPES_USER = {
      admin: [1, 6, 7]
  }

  pg_search_scope :search,
                  against: [:name, :surname, :email],
                  using: {
                      tsearch: {prefix: true}
                  }

  # @todo REF remove security methods to projectUsers
  def current_projects_for_user
    if prime_admin?
      Core::Project.all
    else
      opened_projects = Core::Project.where(type_access: Core::Project::TYPE_ACCESS_CODE[:opened])
      club_projects = (self.cluber? or self.boss?) ? Core::Project.where(type_access: Core::Project::TYPE_ACCESS_CODE[:club]) : []
      closed_projects = self.projects.where(core_projects: {type_access: Core::Project::TYPE_ACCESS_CODE[:closed]})
      projects = opened_projects | club_projects | closed_projects
      projects.sort_by { |c| -c.id }
    end
  end

  def current_projects_for_journal
    if prime_admin?
      Core::Project.active_proc
    else
      opened_projects = Core::Project.active_proc.where(type_access: Core::Project::TYPE_ACCESS_CODE[:opened])
      club_projects = (self.cluber? or self.boss?) ? Core::Project.active_proc.where(type_access: Core::Project::TYPE_ACCESS_CODE[:club]) : []
      closed_projects = self.projects.active_proc.where(core_projects: {type_access: Core::Project::TYPE_ACCESS_CODE[:closed]})
      projects = opened_projects | club_projects | closed_projects
      projects.sort_by { |c| -c.id }
    end
  end

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
    if [1, 6, 7].include? self.type_user
      'модератор'
    elsif self.type_user == 2
      'эксперт'
    elsif self.type_user == 3
      'жюри'
    else
      ''
    end
  end

  def uniq_proc_access?(project)
    return false if project.moderator_id.present? and not (project.moderator_id == self.id or self.type_user == 7)
    true
  end

  # @todo REF remove methods  - for dinamic methods
  def boss?
    [1, 2, 3, 6, 7].include? self.type_user
  end

  def cluber?
    [4, 5, 7].include? self.type_user
  end

  def watcher?
    self.type_user == 5
  end

  def admin?
    [1, 6, 7].include? self.type_user
  end

  def prime_admin?
    [1, 7].include? self.type_user
  end

  def expert?
    self.type_user == 2
  end

  def jury?
    self.type_user == 3
  end

  def role_expert?
    self.role_stat == 2
  end

  def stat_expert?
    self.role_stat == 3
  end

  def add_score(h={})
    #@todo нужно добавить project: h[:project]
    case h[:type]
      when :add_life_tape_post
        self.add_score_by_type(h[:project], 10, :score_g)
      when :plus_comment
        self.add_score_by_type(h[:project], 5, :score_a)
        # self.journals.build(type_event:'useful_comment', project: h[:project], body:"#{h[:comment].content[0..24]}:#{h[:path]}/#{h[:comment].post.id}#comment_#{h[:comment].id}").save!
        self.journals.build(type_event: 'my_add_score_comment', project: h[:project], user_informed: self, body: "5", first_id: h[:comment].id, viewed: false, personal: true).save!

      when :plus_post
        self.add_score_by_type(h[:project], 25, :score_g) if h[:post].instance_of? Core::Essay::Post
        # self.add_score_by_type(h[:project], 50, :score_g) if h[:post].instance_of? Concept::Post
        self.add_score_by_type(h[:project], 500, :score_g) if h[:post].instance_of? Plan::Post

        if h[:post].instance_of? Discontent::Post
          self.add_score_by_type(h[:project], 25, :score_g)
          self.journals.build(type_event: 'my_add_score_discontent', project: h[:project], user_informed: self, body: "25", first_id: h[:post].id, body2: trim_content(h[:post].content), viewed: false, personal: true).save!
          if h[:post].improve_comment
            # comment = "#{get_class_for_improve(h[:post].improve_stage)}::Comment".constantize.find(h[:post].improve_comment)
            comment = get_comment_for_stage(h[:post].improve_stage, h[:post].improve_comment)
            comment.user.add_score_by_type(h[:project], 10, :score_g)
            self.journals.build(type_event: 'my_add_score_discontent_improve', project: h[:project], user_informed: comment.user, body: "10", first_id: h[:post].id, body2: trim_content(h[:post].content), viewed: false, personal: true).save!
          end
        end
        if h[:post].instance_of? Concept::Post
          # self.add_score_by_type(h[:project], h[:post].fullness.nil? ? 40 : h[:post].fullness + 39, :score_g)
          self.add_score_by_type(h[:project], 50, :score_g)
          self.journals.build(type_event: 'my_add_score_concept', project: h[:project], user_informed: self, body: "50", first_id: h[:post].id, body2: trim_content(h[:post].content), viewed: false, personal: true).save!
          if h[:post].improve_comment
            # comment = "#{get_class_for_improve(h[:post].improve_stage)}::Comment".constantize.find(h[:post].improve_comment)
            comment = get_comment_for_stage(h[:post].improve_stage, h[:post].improve_comment)
            comment.user.add_score_by_type(h[:project], 20, :score_g)
            self.journals.build(type_event: 'my_add_score_concept_improve', project: h[:project], user_informed: comment.user, body: "20", first_id: h[:post].id, body2: trim_content(h[:post].content), viewed: false, personal: true).save!
          end
        end
      # self.add_score_by_type(h[:project], 10, :score_g) if h[:post].instance_of? CollectInfo::Post
      when :plus_field
        if h[:post].instance_of? Concept::Post
          # self.add_score_by_type(h[:project], h[:post].fullness.nil? ? 40 : h[:post].fullness + 39, :score_g)
          if h[:type_field] and score_for_concept_field(h[:post], h[:type_field]) > 0
            self.add_score_by_type(h[:project], score_for_concept_field(h[:post], h[:type_field]), :score_g)
            if ['status_name', 'status_content'].include?(h[:type_field]) and h[:post].status_name and h[:post].status_content
              self.journals.build(type_event: 'my_add_score_concept', project: h[:project], user_informed: self, body: "40", first_id: h[:post].id, body2: trim_content(h[:post].content), viewed: false, personal: true).save!
            end
          end
        end
      when :plus_field_all
        if h[:post].instance_of? Concept::Post
          self.add_score_by_type(h[:project], h[:post].fullness.nil? ? 40 : h[:post].fullness, :score_g)
          self.journals.build(type_event: 'my_add_score_concept', project: h[:project], user_informed: self, body: "#{h[:post].fullness.nil? ? 40 : h[:post].fullness}", first_id: h[:post].id, body2: trim_content(h[:post].content), viewed: false, personal: true).save!
        end
      when :to_archive_life_tape_post
        self.add_score_by_type(h[:project], -10, :score_g)
      when :add_discontent_post
        self.add_score_by_type(h[:project], 20, :score_g)
      when :to_archive_plus_comment
        self.add_score_by_type(h[:project], -5, :score_a)
        Journal.destroy_journal_record(h[:project], 'my_add_score_comment', self, h[:comment], true)
      when :to_archive_plus_post
        self.add_score_by_type(h[:project], -score_for_plus_post(h[:post]), :score_g)

        if h[:post].instance_of? Discontent::Post
          Journal.destroy_journal_record(h[:project], 'my_add_score_discontent', self, h[:post], true)
          if h[:post].improve_comment
            comment = get_comment_for_stage(h[:post].improve_stage, h[:post].improve_comment)
            comment.user.add_score_by_type(h[:project], -10, :score_g)
            Journal.destroy_journal_record(h[:project], 'my_add_score_discontent_improve', comment.user, h[:post], true)
          end
        end

      when :to_archive_plus_field
        self.add_score_by_type(h[:project], -score_for_concept_field(h[:post], h[:type_field], true), :score_g)
        if h[:post].instance_of? Concept::Post and ['status_name', 'status_content'].include?(h[:type_field])
          Journal.destroy_journal_record(h[:project], 'my_add_score_concept', self, h[:post], true)
        end
      when :to_archive_plus_field_all
        self.add_score_by_type(h[:project], -(h[:post].fullness.nil? ? 40 : h[:post].fullness), :score_g)
        if h[:post].instance_of? Concept::Post
          Journal.destroy_journal_record(h[:project], 'my_add_score_concept', self, h[:post], true)
        end
    end
  end

  def add_score_by_type(project, score, type = :score_g)
    ps = self.core_project_scores.by_project(project).first_or_create
    ps.update_attributes!(score: score +ps.score, type => ps.read_attribute(type)+score)
    Award.reward(user: self, old_score: ps.score-score, project: project, score: ps.score, type: 'max')
    # self.user_project_scores(project).update_attributes!(score: score+self.score, type => self.read_attribute(type)+score)
  end

  def can_vote_for(stage, project)
    if stage == :collect_info and project.status == 2 and project.get_free_votes_for(self, 'collect_info') > 0
      return true
    elsif stage == :discontent and project.status == 6 and project.get_free_votes_for(self, 'discontent') > 0
      return true
    elsif stage == :concept and project.status == 8 and project.get_free_votes_for(self, 'concept') > 0
      return true
    elsif stage == :novation and project.status == 10 and project.get_free_votes_for(self, 'novation') > 0
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

  def can_edit_project?(project)
    #@todo нужно мигрировать все данные всех проектов
    true
    #project.project_users.by_type(1).include?(self) || project.project_users.by_type(0).include?(self)
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

  def content_for_project(project)
    if project.current_stage_values[:type_stage] == Core::Project::LIST_STAGES.first.second[:type_stage]
      core_aspects.by_project(project)
    else
      send(project.current_stage_values[:type_stage]).for_project(project.id)
    end
  end

  def plan_vote_status(post, type)
    self.plan_post_votings.by_post(post).by_type(type).first.try(:status) || 0
  end
end
