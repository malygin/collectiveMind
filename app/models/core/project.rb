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
  has_many :novations_for_vote, -> { where status: [1, 2] }, class_name: 'Novation::Post'

  has_many :plan_post, class_name: 'Plan::Post'
  has_many :plan_published_post, -> { where status: 1 }, class_name: 'Plan::Post'
  has_many :completion_plan_posts, -> { where completion_status: true }, class_name: 'Plan::Post'
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
  scope :active_proc, -> { where('core_projects.status < ?', STATUS_CODES[:complete]) }
  scope :access_proc, -> access_proc { where(core_projects: {type_access: access_proc}) }

  STAGES = {
    1 => {name: 'Введение в процедуру',description: 'Знакомство с описанием ситуации и ее различных аспектов' ,type_stage: :collect_info_posts, cabinet_url: :aspect_posts,  active: true,
      substages: {
        0 => {name: 'Изучение и обсуждение БЗ', active: true, code: :aspects_esimate},
        1 => {name: 'Расширенная БЗ', active: true, code: :aspects_learn},
        2 => {name: 'Голосование за аспекты', active: true, code: :aspects_voting},
      }
    },
    2 => {name: 'Анализ ситуации',description: 'Выявление проблем текущей ситуации', type_stage: :discontent_posts, active: true,
          substages: {
              0 => {name: 'Поиск несовершенств', active: true, code: :discontents_add},
              1 => {name: 'Голосование', active: true, code: :discontents_voting},
          }
    },
    3 => {name: 'Сбор идей',description: 'Поиск идей по устранению проблем текущей ситуации', type_stage: :concept_posts, active: true,
          substages: {
              0 => {name: 'Поиск идей', active: true, code: :concepts_add},
              1 => {name: 'Голосование', active: true, code: :discontents_voting},
          }
    },
    4 => {name: 'Объединение идей в пакеты',description: 'Объединение идей в пакеты', type_stage: :novation_posts, active: true,
          substages: {
              0 => {name: 'Создание пакетов', active: true, code: :novations_add},
              1 => {name: 'Голосование', active: true, code: :novations_voting},
          }
    },
    5 => {name: 'Проектное предложение',description: 'Формирование проектных предложений на основе пакетов идей', type_stage: :plan_posts, active: true,
          substages: {
              0 => {name: 'Создание проектных предложений', active: true, code: :plans_add},
              1 => {name: 'Голосование', active: true, code: :plans_voting},

          }
    },
    6 => {name: 'Подведение итогов',description: 'Оценка проектов', type_stage: :estimate_posts, active: true,
    },
    7 => {name: 'Завершение процедуры',description: 'Завершение процедуры', type_stage: :completion_proc_posts, active: true,
    }
  }.freeze

  TYPE_ACCESS = {
      opened: {name: I18n.t('form.project.opened'), code: 0},
      club: {name: I18n.t('form.project.club'), code: 1},
      closed: {name: I18n.t('form.project.closed'), code: 2},
  }.freeze


  validates :name, presence: true



  def current_stage_type
    STAGES[stage[0].to_i][:type_stage]
  end

  def current_stage_name
    STAGES[stage[0].to_i][:name]
  end

  def current_stage_type_for_cabinet_url
    if (STAGES[stage[0].to_i][:cabinet_url])
      STAGES[stage[0].to_i][:cabinet_url].to_s.downcase.singularize
    else
      STAGES[stage[0].to_i][:type_stage].to_s.downcase.singularize
    end
  end

  # return main stage for stage '2:3' it will be 2
  def main_stage
    stage[0].to_i
  end

  # return main stage for stage '2:3' it will be 3, if  it '2' return 0
  def sub_stage
    stage[2] ? stage[2].to_i : 0
  end

  # move to next stage if it '1:2' and we haven't '1:3' then go to '2:0', unless go to '1:3
  def go_to_next_stage
    if  STAGES[main_stage][:substages] and  STAGES[main_stage][:substages][sub_stage + 1]
      self.stage= "#{main_stage}:#{sub_stage+1}"
    else
      self.stage= "#{main_stage+1}:0"
    end
    self.save
  end

  # move to prev stage if it '7:0' and we haven't '6:1' then go to '6:0', unless go to '6:1'
  def go_to_prev_stage
    if  sub_stage > 0
      self.stage= "#{main_stage}:#{sub_stage-1}"
    else
      # if we haven't substages in STAGES  for prev stage, then we set new_sub_stage to 0
      new_sub_stage = ( STAGES[main_stage-1][:substages] ?  (STAGES[main_stage-1][:substages].size - 1) : 0 )
      self.stage= "#{main_stage-1}:#{new_sub_stage}"
    end
    self.save
  end

  def type_for_questions
    stage == '1:0' ? 0 : 1
  end


  def closed?
    type_access == TYPE_ACCESS[:closed][:code]
  end

  def type_access_name
    TYPE_ACCESS[type_access]
  end

  def moderators
    users_in_project.where(users: {type_user: User::TYPES_USER[:admin]})
  end

  def concepts_without_aspect
    self.concept_ongoing_post.includes(:concept_post_discontents).where(concept_post_discontents: {post_id: nil})
  end

  def discontents_without_aspect
    self.discontents.includes(:discontent_post_aspects).where(discontent_post_aspects: {post_id: nil})
  end

  def get_free_votes_for(user, stage)
    case stage
      when :collect_info
        self.proc_main_aspects.size - user.voted_aspects.by_project(self.id).size
      when :discontent
        self.discontent_for_vote.size - user.voted_discontent_posts.by_project(self.id).size
      when :concept
        self.concept_ongoing_post.size - user.voted_concept_post.by_project(self.id).size
      when :novation
        self.novations.size - user.voted_novation_post.by_project(self.id).size
    end
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

  def concept_comments
    Concept::Comment.joins("INNER JOIN concept_posts ON concept_comments.post_id = concept_posts.id").
        where("concept_posts.project_id = ?", self.id)
  end

  def discontent_comments
    Discontent::Comment.joins("INNER JOIN discontent_posts ON discontent_comments.post_id = discontent_posts.id").
        where("discontent_posts.project_id = ?", self.id)
  end

  def project_access(user)
    type_access == 0 ? true : (users.include?(user) || user.boss?)
  end

  def get_other_aspects_sorted_by(sort_rule)
    if sort_rule == 'sort_by_comments'
      self.other_main_aspects.sort_comments
    elsif sort_rule == 'sort_by_date'
      self.other_main_aspects.created_order
    else
      self.other_main_aspects
    end
  end

  def get_main_aspects_sorted_by(sort_rule)
    if sort_rule == 'sort_by_comments'
      self.proc_main_aspects.sort_comments
    elsif sort_rule == 'sort_by_date'
      self.proc_main_aspects.created_order
    else
      self.proc_main_aspects
    end
  end

end
