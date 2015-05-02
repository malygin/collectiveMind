class Core::Project < ActiveRecord::Base
  belongs_to :project_type, class_name: 'Core::ProjectType', foreign_key: :project_type_id
  has_one :settings, class_name: 'Core::ProjectSetting', dependent: :destroy
  accepts_nested_attributes_for :settings
  has_many :aspects, class_name: 'Core::Aspect::Post'
  has_many :main_aspects, -> { where core_aspect_id: nil }, class_name: 'Core::Aspect::Post'
  has_many :proc_aspects, -> { where status: 0 }, class_name: 'Core::Aspect::Post'
  has_many :proc_main_aspects, -> { where(core_aspect_id: nil, status: 0) }, class_name: 'Core::Aspect::Post'
  has_many :other_main_aspects, -> { where(core_aspect_id: nil, status: 1) }, class_name: 'Core::Aspect::Post'

  has_many :discontents, class_name: 'Discontent::Post'
  has_many :discontent_ongoing_post, -> { where status: 0 }, class_name: 'Discontent::Post'
  has_many :discontent_accepted_post, -> { where status: 2 }, class_name: 'Discontent::Post'
  has_many :discontent_for_admin_post, -> { where status: 1 }, class_name: 'Discontent::Post'
  has_many :discontent_grouped_post, -> { where status: 4 }, class_name: 'Discontent::Post'
  has_many :discontent_for_vote, -> { where status: [2, 4] }, class_name: 'Discontent::Post'

  has_many :discontent_groups, -> { where status: 2 }, class_name: 'Discontent::PostGroup'

  has_many :concepts, class_name: 'Concept::Post'
  has_many :concept_ongoing_post, -> { where status: 0 }, class_name: 'Concept::Post'
  has_many :concept_accepted_post, -> { where status: 2 }, class_name: 'Concept::Post'
  has_many :concept_for_admin_post, -> { where status: 1 }, class_name: 'Concept::Post'

  has_many :novations, class_name: 'Novation::Post'

  has_many :plan_post, -> { where status: 0 }, class_name: 'Plan::Post'
  has_many :estimate_posts, -> { where status: 0 }, class_name: 'Estimate::Post'

  has_many :project_users
  has_many :users, through: :project_users
  has_many :knowbase_posts, class_name: 'Core::Knowbase::Post'

  has_many :core_project_scores, class_name: 'Core::ProjectScore'
  has_many :core_project_users, class_name: 'Core::ProjectUser'
  has_many :users_in_project, through: :core_project_users, source: :user, class_name: 'User'

  has_many :essays, -> { where status: 0 }, class_name: 'Core::Essay::Post'
  has_many :groups
  has_many :journal_mailers, class_name: 'JournalMailer'
  has_many :journals
  has_many :news, class_name: 'News'
  #has_many :project_score_users, class_name: 'User', through: :core_project_scores, source: :user
  has_many :technique_list_projects, class_name: 'Technique::ListProject', dependent: :destroy
  has_many :techniques, through: :technique_list_projects, source: :technique_list, class_name: 'Technique::List'

  after_create { build_settings.save }

  default_scope { order('id DESC') }
  scope :club_projects, ->(user) { where(type_access: TYPE_ACCESS_CODE[:club]) if user.cluber? or user.boss? }
  scope :active_proc, -> { where('core_projects.status < ?', STATUS_CODES[:complete]) }
  scope :access_proc, -> access_proc { where(core_projects: {type_access: access_proc}) }

  LIST_STAGES = {1 => {name: 'Введение в процедуру', type_stage: :collect_info_posts, status: [0, 1, 2, 20]},
                 2 => {name: 'Анализ ситуации', type_stage: :discontent_posts, status: [3, 4, 5, 6]},
                 3 => {name: 'Сбор идей', type_stage: :concept_posts, status: [7, 8]},
                 4 => {name: 'Объединение идей в пакеты', type_stage: :novation_posts, status: [9, 10]},
                 5 => {name: 'Разработка проектов', type_stage: :plan_posts, status: [11, 12]},
                 6 => {name: 'Оценивание проектов', type_stage: :estimate_posts, status: [13, 14, 15]}}.freeze

  TYPE_ACCESS = {
      0 => I18n.t('form.project.opened'),
      1 => I18n.t('form.project.club'),
      2 => I18n.t('form.project.closed'),
  }.freeze

  TYPE_ACCESS_CODE = {
      opened: 0,
      club: 1,
      closed: 2
  }.freeze

  STATUS_CODES = {
      prepare: 0, # 1 round questions
      collect_info: 1, # 2 round questions
      vote_aspects: 2, # vote
      discontent: 3,
      group_discontent: 4,
      discuss_discontent: 5,
      vote_discontent: 6,
      concept: 7,
      vote_concept: 8,
      novation: 9,
      vote_novation: 10,
      plan: 11,
      vote_plan: 12,
      estimate: 13,
      vote_final: 14,
      wait_decision: 15,
      complete: 20
  }.freeze

  validates :name, presence: true
  validates :status, inclusion: {in: STATUS_CODES.values}
  validates :type_access, inclusion: {in: TYPE_ACCESS_CODE.values}

  def closed?
    type_access == TYPE_ACCESS_CODE[:closed]
  end

  STATUS_CODES.keys.each do |method_name|
    define_method :"stage_#{method_name}?" do
      status == STATUS_CODES[method_name]
    end
  end

  # тип вопроса в зависимости от этапа
  def type_for_questions
    [STATUS_CODES[:prepare], STATUS_CODES[:collect_info]].include?(self.status) ? self.status : STATUS_CODES[:collect_info]
  end

  def current_stage
    LIST_STAGES.select { |key, hash| hash[:status].include? status }
  end

  def current_stage_values
    current_stage.values[0]
  end

  def current_stage_number
    current_stage.keys[0]
  end

  def current_stage_type
    current_stage_values[:type_stage]
  end

  #@todo нужно универсализовать эту логику
  def current_stage_type_for_cabinet
    if current_stage_values[:type_stage] == :collect_info_posts
      'aspect_posts'
    else
      current_stage_values[:type_stage]
    end
  end

  def current_stage_num
    current_stage.first[0]
  end

  def moderators
    users_in_project.where(users: {type_user: User::TYPES_USER[:admin]})
  end

  def current_aspects(current_stage)
    if current_stage == 'collect_info/posts'
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
      when 'collect_info'
        self.proc_main_aspects.size - user.voted_aspects.by_project(self.id).size
      when 'discontent'
        self.discontent_for_vote.size - user.voted_discontent_posts.for_project(self.id).size
      when 'concept'
        self.concept_ongoing_post.size - user.voted_concept_post.by_project(self.id).size
      when 'novation'
        self.novations.size - user.voted_novation_post.by_project(self.id).size
      when 'plan'
        self.stage5.to_i - user.voted_plan_posts.by_project(self.id).size
    end
  end

  def project_access(user)
    case type_access
      when 0
        return true
      when 1
        (user.cluber? && users.include?(user)) || user.boss?
      when 2
        users.include?(user) || user.boss?
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
    TYPE_ACCESS[type_access]
  end

  def able_add_note?
    [3, 4, 5, 6].include?(self.status)
  end

  # def proc_aspects
  #   self.aspects.where(status: 0)
  # end

  def get_united_posts_for_vote(user)
    voted = user.voted_discontent_posts.pluck(:id)
    all_posts = Discontent::Post.where(project_id: id, status: [2, 4]).where.not(id: voted).includes(:post_aspects).order('core_aspect_posts.id')
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

  def current_status?(status)
    sort_list = LIST_STAGES.select { |k, v| v[:type_stage] == status }
    sort_list.values[0][:status].include? self.status
  end

  def current_stage?(stage)
    Core::Project::LIST_STAGES[stage][:status].include? status
  end

  def prev_status
    # @todo здесь круто войдет https://github.com/pluginaweek/state_machine
    # займусь позже)
    if status > 0
      status - 1
    else
      nil
    end
  end

  def next_status
    if status != 20
      status + 1
    else
      nil
    end
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

  def can_edit_on_current_stage(p)
    if p.instance_of? Discontent::Post
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
      when :collect_info_posts
        0
      when :discontent_posts
        3
      when :concept_posts
        7
      when :novation_posts
        9
      when :plan_posts
        11
      when :estimate_posts
        13
    end
  end

  def model_min_stage(model)
    case model
      when 'collect_info_post'
        0
      when 'discontent_post'
        3
      when 'concept_post'
        7
      when 'novation_post'
        9
      when 'plan_post'
        11
      when 'estimate_post'
        13
      else
        0
    end
  end

  def can_add_content?(stage)
    if stage == :collect_info_posts
      return [0, 1].include?(self.status)
    elsif stage == :discontent_posts
      return self.status == 3
    elsif stage == :concept_posts
      return self.status == 7
    elsif stage == :novation_posts
      return self.status == 9
    elsif stage == :plan_posts
      return self.status == 11
    elsif stage == :estimate_posts
      return self.status == 13
    end
    false
  end

  def demo?
    self.type_access == 3
  end

  # def closed?
  #   self.type_access == 2
  # end

  def self.status_title(status)
    case status
      when 0
        'подготовка к процедуре'
      when 1, :collect_info_posts
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

  def set_position_for_aspects
    aspect = Core::Aspect::Post.where(project_id: self, status: 0).first
    unless aspect.position
      aspects = Core::Aspect::Post.scope_vote_top(self.id, "0")
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

  # @todo REF  move to helper

  def date_begin_stage(table_name)
    table_name = table_name.sub('_posts', '').sub('_comments', '')
    if table_name == 'collect_info'
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
    if table_name == 'collect_info'
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

  # Аналитика
  def statistic_visits(duration)
    journals.unscoped.where(type_event: 'visit_save').where(project_id: id).where('journals.created_at > ?', duration)
  end

  # Возвращает статистику открытых страниц пользователями
  # Формат дата: user.to_s: кол-во посещенных страниц
  # type_users - строка, соответствующая скоупу в журнале
  def count_pages(type_users = 'not_moderators', duration = 5.days.ago)
    pages = statistic_visits(duration).send(type_users).joins(:user).
        select("COUNT(*) AS count_pages, DATE_TRUNC('day', journals.created_at) as day, user_id AS user_id").
        group("DATE_TRUNC('day', journals.created_at), user_id").order('count_pages DESC')
    dates = []
    users = {}
    pages.each do |page|
      dates << page.day
      users[page.user] ||= {}
      users[page.user][page.day] = page.count_pages
    end
    {dates: dates.uniq.sort, users: users}
  end

  def count_people(type_users = 'not_moderators', duration = 5.days.ago)
    # Запрос возвращает хеш, где ключ - дата, значение - количество юзеров
    # например, {2015-01-25 00:00:00 +0300=>1, 2015-01-26 00:00:00 +0300=>1}
    # и затем мы преобразуем дату для работы на клиенте (хз, почему именно так)
    visits = statistic_visits(duration).send(type_users).select('DISTINCT user_id').group("DATE_TRUNC('day', journals.created_at)").count
    visit_data = []
    visits.each do |visit, minutes|
      visit_data << {x: (visit.to_datetime.to_f * 1000).to_i, y: minutes}
    end
    [{key: 'Посетителей', values: visit_data}]
  end

  def average_time(type_users = 'not_moderators', duration = 5.days.ago)
    visits = statistic_visits(duration).send(type_users).select("DATE_TRUNC('day', journals.created_at) as day,
                  round(CAST(float8 (extract(epoch from sum(journals.updated_at - journals.created_at)::INTERVAL)/60) as numeric), 2) / count(DISTINCT journals.user_id) as minutes").
        group("DATE_TRUNC('day', journals.created_at)")
    visit_data = []
    visits.each do |visit|
      visit_data << {x: (visit.day.to_datetime.to_f * 1000).to_i, y: visit.minutes}
    end
    [{key: 'Среднее время', values: visit_data}]
  end


  def count_actions(type_users = 'for_moderators', duration = 5.days.ago)
    actions = journals.joins(:user).where('journals.created_at > ?', duration).send(type_users).
        select("COUNT(*) AS count_actions, DATE_TRUNC('day', journals.created_at) as day, user_id AS user_id").
        group("DATE_TRUNC('day', journals.created_at), user_id").order('count_actions DESC')
    dates = []
    users = {}
    actions.each do |action|
      dates << action.day
      users[action.user] ||= {}
      users[action.user][action.day] = action.count_actions
    end
    {dates: dates.uniq.sort, users: users}
  end
end
