class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include ApplicationHelper

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lastseenable
  attr_accessor :secret, :secret2, :secret3

  has_many :core_project_scores, class_name: 'Core::ProjectScore'
  has_many :help_posts, class_name: 'Core::Help::Post', through: :help_questions, source: :post
  has_many :journals
  has_many :discontent_posts, class_name: 'Discontent::Post'
  has_many :core_aspects, class_name: 'Core::Aspect'
  has_many :essay_posts, class_name: 'Core::Essay::Post'
  has_many :concept_posts, class_name: 'Concept::Post'
  has_many :aspect_votings, class_name: 'CollectInfo::Voting'
  has_many :voted_aspects, through: :aspect_votings, source: :core_aspect, class_name: 'Core::Aspect'
  has_many :post_votings, class_name: 'Discontent::Voting'
  has_many :voted_discontent_posts, through: :post_votings, source: :discontent_post, class_name: 'Discontent::Post'
  has_many :concept_post_votings, class_name: 'Concept::Voting'
  has_many :voted_concept_post_aspects, through: :concept_post_votings, source: :concept_post_aspect, class_name: 'Concept::PostAspect'
  has_many :plan_post_votings, class_name: 'Plan::Voting'
  has_many :voted_plan_posts, through: :plan_post_votings, source: :plan_post, class_name: 'Plan::Post'
  has_many :core_project_users, class_name: 'Core::ProjectUser'
  has_many :projects, through: :core_project_users, source: :core_project, class_name: 'Core::Project'
  has_many :user_awards, class_name: 'Core::UserAward'
  has_many :awards, through: :user_awards
  has_many :moderator_messages
  has_many :user_checks, class_name: 'Util::Unit::UserCheck'
  has_many :group_users
  has_many :groups, through: :group_users
  has_many :group_chat_messages
  has_many :plan_posts, class_name: 'Plan::Post'
  has_many :user_answers, class_name: 'UserAnswers'

  default_scope { order('id DESC') }
  scope :check_field, ->(p, c) { where(project: p.id, status: 't', check_field: c) }
  scope :without_added, ->(users) { where.not(id: users) unless users.empty? }
  scope :not_admins, -> { where 'users.type_user NOT IN (?) or users.type_user IS NULL', TYPES_USER[:admin] }

  validates :name, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: {
                               thumb: '57x74>',
                               normal: '250x295>'
                           }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  TYPES_USER = {
      admin: [1, 6, 7]
  }

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

  def current_projects_for_ordinary_user
    opened_projects = Core::Project.active_proc.where(type_access: Core::Project::TYPE_ACCESS_CODE[:opened])
    club_projects = self.cluber? ? Core::Project.active_proc.where(type_access: Core::Project::TYPE_ACCESS_CODE[:club]) : []
    closed_projects = self.projects.active_proc.where(core_projects: {type_access: Core::Project::TYPE_ACCESS_CODE[:closed]})
    opened_projects | club_projects | closed_projects
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

  def answered_for_help_stage?(stage)
    self.help_posts.pluck(:stage).include? stage
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

  def have_essay_for_stage(project, stage)
    !self.essay_posts.where(project_id: project, stage: stage, status: 0).empty?
  end

  def aspects(id)
    if self.core_aspects.empty?
      Core::Aspect.where(project_id: id)
    else
      self.core_aspects
    end
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
        self.add_score_by_type(h[:project], 25, :score_g) if h[:post].instance_of? Essay::Post
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
      when :approve_advice
        self.add_score_by_type(h[:project], 10, :score_g)
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
      when :useful_advice
        add_score_by_type(h[:project], 10, :score_g)
    end
  end

  def add_score_by_type(project, score, type = :score_g)
    ps = self.core_project_scores.by_project(project).first_or_create
    ps.update_attributes!(score: score +ps.score, type => ps.read_attribute(type)+score)
    Award.reward(user: self, old_score: ps.score-score, project: project, score: ps.score, type: 'max')
    # self.user_project_scores(project).update_attributes!(score: score+self.score, type => self.read_attribute(type)+score)
  end

  def can_vote_for(stage, project)
    if project.status == 2 and project.get_free_votes_for(self, 'lifetape') > 0
      return true
    end
    if project.status == 6 and !project.get_united_posts_for_vote(self).empty?
      return true
    end
    if project.status == 8
      disposts = Discontent::Post.where(project_id: project, status: 4).order(:id)
      last_vote = self.concept_post_votings.by_project_votings(project).last
      return true if last_vote.nil?
      dispost = self.able_concept_posts_for_vote(project, disposts, last_vote)
      if dispost
        concept_posts = dispost.dispost_concepts.by_status(0).order('concept_posts.id')
        count_now = self.concept_post_votings.by_project_votings(project).where(discontent_post_id: last_vote.discontent_post_id, concept_post_aspect_id: last_vote.concept_post_aspect_id).count
        unless concept_posts[dispost.id != last_vote.discontent_post_id ? 0 : count_now].nil?
          return true
        end
      end
    end
    if project.status == 11 and self.voted_plan_posts.by_project(project.id).size == 0
      return true
    end
    false
  end

  def able_concept_posts_for_vote(project, disposts, last_vote, num = 0)
    last_vote = self.concept_post_votings.by_project_votings(project).last if last_vote.nil?
    unless last_vote.nil?
      dis_post = last_vote.discontent_post
      num = disposts.index dis_post
    end
    i = num.nil? ? 0 : num
    while disposts[i].nil? ? false : true
      discontent_post = disposts[i]
      concept_posts = discontent_post.dispost_concepts.by_status(0).order('concept_posts.id')
      if last_vote.nil?
        if concept_posts.size > 1
          return discontent_post
        end
      elsif discontent_post.id != last_vote.discontent_post_id
        if concept_posts.size > 1
          return discontent_post
        end
      else
        count_now = self.concept_post_votings.by_project_votings(project).where(discontent_post_id: last_vote.discontent_post_id, concept_post_aspect_id: last_vote.concept_post_aspect_id).count
        unless concept_posts[count_now+1].nil?
          return discontent_post
        end
      end
      i += 1
    end
  end

  def advices_for(post)
    post.advices.where(user: id)
  end

  def my_journals(project)
    events = Journal.events_for_my_feed project.id, id
    g = events.group_by { |e| e.first_id }
    g.collect { |k, v| [v.first, v.size] }
  end


  def looked_chat
    update_attributes! last_seen_chat_at: Time.now
  end

  def self.search(name, surname, email)
    where('LOWER(name) like LOWER(?) OR LOWER(surname) like LOWER(?) OR LOWER(email) like LOWER(?)', "%#{name}%", "%#{surname}%", "%#{email}%").
        sort_by { |user| user[:name].downcase or user[:surname].downcase or user[:email].downcase }
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

  def not_ready_for_concept?(project)
    if project_user_for(project).nil?
      false
    else
      !project_user_for(project).ready_to_concept
    end
  end
end
