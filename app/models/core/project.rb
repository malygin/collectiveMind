class Core::Project < ActiveRecord::Base
##### status 
# 0 - prepare to procedure
# 1 - life_tape
# 2 - vote fo aspects
# 3 - Discontent
# 4 - voting for Discontent
# 5 - Concept 
# 6 - voiting for Concept
# 7 - plan
# 8 - voiting for plan
# 9 - estimate
# 10 - final vote
# 11 - wait for decision
# 20  - complete
####### type_access
# 0 open for everyone and everyone may be participant
# 1 open for everyone but participant may be only with rights
# 2  closed, only for participant
####### type_project
# 0 normal
# 1 invisible
####### new type_access
# 0 opened for all
# 1 only for ratio club and all moderators
# 2 closed, only for invited and prime moderators
# 3 demo (opened for all)
# 4 testing
# 5 preparing procedure
# 10 disabled

  attr_accessible :desc, :postion, :secret, :type_project, :name, :short_desc, :knowledge, :status, :type_access,
                  :url_logo, :stage1, :stage2, :stage3, :stage4, :stage5, :color, :code, :advices_concept, :advices_discontent,
                  :date_12,:date_23,:date_34,:date_45,:date_56


  has_many :life_tape_posts, -> { where status: 0 }, class_name: 'LifeTape::Post'
  has_many :aspects, class_name: 'Discontent::Aspect'

  has_many :discontents, class_name: 'Discontent::Post'
  has_many :discontent_ongoing_post, -> { where status: 0 }, class_name: 'Discontent::Post'
  has_many :discontent_accepted_post, -> { where status: 2 }, class_name: 'Discontent::Post'
  has_many :discontent_for_admin_post, -> { where status: 1 }, class_name: 'Discontent::Post'

  has_many :concepts, class_name: 'Concept::Post'
  has_many :concept_ongoing_post, -> { where status: 0 }, class_name: 'Concept::Post'
  has_many :concept_accepted_post, -> { where status: 2 }, class_name: 'Concept::Post'
  has_many :concept_for_admin_post, -> { where status: 1 }, class_name: 'Concept::Post'

  has_many :plan_post, -> { where status: 0 }, class_name: 'Plan::Post'
  has_many :estimate_posts, -> { where status: 0 }, class_name: 'Estimate::Post'

  has_many :project_users
  has_many :users, through: :project_users
  has_many :knowbase_posts, class_name: 'Knowbase::Post'

  has_many :core_project_scores, class_name: 'Core::ProjectScore'

  has_many :core_project_users, class_name: 'Core::ProjectUser'
  has_many :users_in_project, through: :core_project_users, source: :user, class_name: 'User'

  has_many :essays, -> { where status: 0 }, class_name: 'Essay::Post'
  has_many :groups
  has_many :journal_mailers, class_name: 'JournalMailer'
  has_many :journals
  #has_many :project_score_users, class_name: 'User', through: :core_project_scores, source: :user
  scope :club_projects, ->(user) { where(type_access: 1) if user.cluber? or user.boss? }
  scope :active_proc, -> { where("core_projects.status < ?", 20) }
  scope :access_proc, -> access_proc { where(core_projects: {type_access: access_proc}) }

  LIST_STAGES = {1 => {name: 'Введение в процедуру', type_stage: :life_tape_posts, status: [0, 1, 2, 20]},
                 2 => {name: 'Анализ ситуации', type_stage: :discontent_posts, status: [3, 4, 5, 6]},
                 3 => {name: 'Дизайн будущего', type_stage: :concept_posts, status: [7, 8]},
                 4 => {name: 'Разработка проектов', type_stage: :plan_posts, status: [9]},
                 5 => {name: 'Оценивание проектов', type_stage: :estimate_posts, status: [10, 11, 12, 13]}}.freeze

  def moderators
    users_in_project.where(users: {type_user: User::TYPES_USER[:admin]})
  end

  def current_aspects(current_stage)
    if current_stage == 'life_tape/posts'
      self.aspects.main_aspects.order(:id)
    else
      if self.proc_aspects.main_aspects.first.present? and self.proc_aspects.main_aspects.first.position.present?
        self.proc_aspects.main_aspects.order("position DESC")
      else
        self.proc_aspects.main_aspects.order(:id)
      end
    end
  end

  def concepts_without_aspect
    self.concept_ongoing_post.includes(:concept_post_discontents).where(concept_post_discontents: {post_id: nil})
  end

  def discontents_without_aspect
    self.discontents.includes(:discontent_post_aspects).where(discontent_post_aspects: {post_id: nil})
  end

  def stage1_count
    self.stage1 > self.proc_aspects.size ? self.proc_aspects.size : self.stage1
  end

  def get_free_votes_for(user, stage)
    case stage
      when 'lifetape'
        self.stage1_count - user.voted_aspects.by_project(self.id).size
      when 'plan'
        self.stage5.to_i - user.voted_plan_posts.by_project(self.id).size
    end
  end

  def project_access(user)
    type_project = self.type_access
    type_user = user.type_user

    if [1, 7].include?(type_user) and [0, 1, 2, 3, 4, 5].include?(type_project)
      true
    elsif [6].include?(type_user) and [0, 1, 3, 4, 5].include?(type_project)
      true
    elsif [2, 3].include?(type_user) and [0, 1, 3].include?(type_project)
      true
    elsif [4, 5].include?(type_user) and [0, 1, 3].include?(type_project)
      true
    elsif [8].include?(type_user) and [0, 3].include?(type_project)
      true
    elsif [0, 3].include?(type_project)
      true
    elsif [2].include?(type_project) and user.projects.include?(self)
      true
    else
      false
    end
  end

  def uniq_proc_access?(user)
    return false if self.moderator_id.present? and not (self.moderator_id == user.id or user.type_user == 7)
    true
  end

  def uniq_proc?
    self.moderator_id.present?
  end

  def type_access_name
    type_project = self.type_access

    case type_project
      when 0
        'Открытая'
      when 1
        'Клубная'
      when 2
        'Закрытая'
      when 3
        'Демо'
      when 4
        'Тестовая'
      when 5
        'Подготовка'
      else
        'Не задано'
    end
  end

  def able_add_note?
    [3, 4, 5, 6].include?(self.status)
  end

  def proc_aspects
    self.aspects.where(status: 0)
  end

  def get_united_posts_for_vote(user)
    voted = user.voted_discontent_posts.pluck(:id)
    Discontent::Post.united_for_vote(self.id, voted)
  end

  def get_concept_posts_for_vote(user)
    voted = user.concept_post_votings.pluck(:id)
    Concept::Post.united_for_vote(self.id, voted)
  end


  def current_status?(status)
    sort_list = LIST_STAGES.select { |k, v| v[:type_stage] == status }
    sort_list.values[0][:status].include? self.status
  end

  def stage_style(status)
    return 'disabled' if self.status < status_number(status)
    return 'active' if current_status?(status)
  end

  def stage_style_link(name_page, status)
    return 'disabled' if self.status < status_number(status)
    return 'current' if current_page?(name_page, status)
  end


  def current_page?(page, status)
    sort_list = LIST_STAGES.select { |k, v| v[:type_stage] == status }
    sort_list.values[0][:name] == page

  end

  def redirect_to_current_stage
    sort_list = LIST_STAGES.select { |k, v| v[:status].include? self.status }
    sort_list.values[0][:type_stage]
  end

  def can_edit_on_current_stage(p)
    if p.instance_of? LifeTape::Post
      return true
    elsif p.instance_of? Discontent::Post
      return self.status == 3
    elsif p.instance_of? Concept::Post
      return self.status == 7
    elsif p.instance_of? Plan::Post
      return self.status == 9
    elsif p.instance_of? Estimate::Post
      return self.status == 10
    end
    return false
  end

  def status_number(status)
    case status
      when :life_tape_posts
        1
      when :discontent_posts
        3
      when :concept_posts
        7
      when :plan_posts
        9
      when :estimate_posts
        10
    end
  end

  def model_min_stage(model)
    case model
      when 'life_tape_post'
        0
      when 'discontent_post'
        3
      when 'concept_post'
        7
      when 'plan_post'
        9
      when 'estimate_post'
        10
      else
        0
    end
  end

  def demo?
    self.type_access == 3
  end

  def closed?
    self.type_access == 2
  end

  def status_title(status = self.status)
    case status
      when 0
        'подготовка к процедуре'
      when 1, :life_tape_posts
        I18n.t('stages.life_tape')
      when 2
        'голосование за темы и рефлексия'
      when 3, :discontent_posts
        I18n.t('stages.discontent')
      when 4
        'группировка несовершенств'
      when 5
        'обсуждение сгруппированных несовершенств'
      when 6
        'голосование за несовершенства и рефлексия'
      when 7, :concept_posts
        I18n.t('stages.concept')
      when 8
        'голосование за нововведения и рефлексия'
      when 9, :plan_posts
        'Создание проектов'
      when 10, :estimate_posts
        'Выставление оценок'
      when 11
        'голосование за проекты'
      when 12
        'подведение итогов'
      else
        'завершена'
    end
  end

  def essay_count(stage)
    self.essays.by_stage(stage)
  end

  def problems_comments_for_improve
    life_tape_comments = LifeTape::Comment.joins("INNER JOIN life_tape_posts ON life_tape_comments.post_id = life_tape_posts.id").
        where("life_tape_posts.project_id = ? and life_tape_comments.discontent_status = 't'", self.id)
    discontent_comments = Discontent::Comment.joins("INNER JOIN discontent_posts ON discontent_comments.post_id = discontent_posts.id").
        where("discontent_posts.project_id = ? and discontent_comments.discontent_status = 't'", self.id)
    comments_all = life_tape_comments | discontent_comments
    comments_all.sort_by { |c| c.improve_disposts.size }
  end

  def ideas_comments_for_improve
    life_tape_comments = LifeTape::Comment.joins("INNER JOIN life_tape_posts ON life_tape_comments.post_id = life_tape_posts.id").
        where("life_tape_posts.project_id = ? and life_tape_comments.concept_status = 't'", self.id)
    discontent_comments = Discontent::Comment.joins("INNER JOIN discontent_posts ON discontent_comments.post_id = discontent_posts.id").
        where("discontent_posts.project_id = ? and discontent_comments.concept_status = 't'", self.id)
    concept_comments = Concept::Comment.joins("INNER JOIN concept_posts ON concept_comments.post_id = concept_posts.id").
        where("concept_posts.project_id = ? and concept_comments.concept_status = 't'", self.id)
    comments_all = life_tape_comments | discontent_comments | concept_comments
    comments_all.sort_by { |c| c.improve_concepts.size }
  end

  def set_position_for_aspects
    aspect = Discontent::Aspect.where(project_id: self, status: 0).first
    unless aspect.position
      aspects = Discontent::Aspect.scope_vote_top(self.id, "0")
      aspects.each do |asp|
        asp.update_attributes(position: asp.voted_users.size)
      end
    end
  end

  def set_date_for_stage
    if self.status == 3
      self.update_attributes(date_12: Time.now.utc)
    elsif self.status == 7
      self.update_attributes(date_23: Time.now.utc)
    elsif self.status == 9
      self.update_attributes(date_34: Time.now.utc)
    elsif self.status == 10
      self.update_attributes(date_45: Time.now.utc)
    elsif self.status == 20
      self.update_attributes(date_56: Time.now.utc)
    end
  end

  def concept_comments
    Concept::Comment.joins("INNER JOIN concept_posts ON concept_comments.post_id = concept_posts.id").
      where("concept_posts.project_id = ?", self.id)
  end

  def discontent_comments
    Discontent::Comment.joins("INNER JOIN discontent_posts ON discontent_comments.post_id = discontent_posts.id").
        where("discontent_posts.project_id = ?", self.id)
  end

  def lifetape_comments
    LifeTape::Comment.joins("INNER JOIN life_tape_posts ON life_tape_comments.post_id = life_tape_posts.id").
        where("life_tape_posts.project_id = ?", self.id)
  end

  def date_begin_stage(table_name)
    table_name = table_name.sub('_posts','').sub('_comments', '')
    if table_name == 'life_tape'
      self.created_at
    elsif table_name == 'discontent'
      self.date_12
    elsif table_name == 'concept'
      self.date_23
    elsif table_name == 'plan'
      self.date_34
    elsif table_name == 'estimate'
      self.date_45
    end
  end

  def date_end_stage(table_name)
    table_name = table_name.sub('_posts', '').sub('_comments', '')
    if table_name == 'life_tape'
      self.date_12
    elsif table_name == 'discontent'
      self.date_23
    elsif table_name == 'concept'
      self.date_34
    elsif table_name == 'plan'
      self.date_45
    elsif table_name == 'estimate'
      self.date_56
    end
  end

end
