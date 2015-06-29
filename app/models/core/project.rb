class Core::Project < ActiveRecord::Base
  belongs_to :project_type, class_name: 'Core::ProjectType', foreign_key: :project_type_id

  has_one :settings, class_name: 'Core::ProjectSetting', dependent: :destroy
  accepts_nested_attributes_for :settings

  has_many :aspects, class_name: 'Aspect::Post'
  has_many :main_aspects, -> { where(core_aspect_id: nil, status: 0) }, class_name: 'Aspect::Post'
  has_many :other_aspects, -> { where(core_aspect_id: nil, status: 1) }, class_name: 'Aspect::Post'

  has_many :discontents, class_name: 'Discontent::Post'
  has_many :discontents_for_discussion, -> { where status: [0, 1] }, class_name: 'Discontent::Post'
  has_many :discontents_for_vote, -> { where status: [0, 1] }, class_name: 'Discontent::Post'
  has_many :discontents_approved, -> { where status: 2 }, class_name: 'Discontent::Post'

  has_many :concepts, class_name: 'Concept::Post'
  has_many :concepts_for_discussion, -> { where status: [0, 1] }, class_name: 'Concept::Post'
  has_many :concepts_for_vote, -> { where status: [0, 1] }, class_name: 'Concept::Post'

  has_many :novations, class_name: 'Novation::Post'
  has_many :novations_for_discussion, -> { where status: 1 }, class_name: 'Novation::Post'
  has_many :novations_for_vote, -> { where status: 1 }, class_name: 'Novation::Post'

  has_many :plans, class_name: 'Plan::Post'
  has_many :plans_for_discussion, -> { where status: 1 }, class_name: 'Plan::Post'
  has_many :plans_approved, -> { where status: 2  }, class_name: 'Plan::Post'

  has_many :estimates, -> { where status: 0 }, class_name: 'Estimate::Post'

  has_many :project_users
  has_many :users, through: :project_users

  has_many :knowbase_posts, class_name: 'Core::Knowbase::Post'

  has_many :core_project_scores, class_name: 'Core::ProjectScore'

  has_many :journal_mailers, class_name: 'JournalMailer'
  has_many :journals
  has_many :news, class_name: 'News'

  has_many :technique_list_projects, class_name: 'Technique::ListProject', dependent: :destroy
  has_many :techniques, through: :technique_list_projects, source: :technique_list, class_name: 'Technique::List'

  after_create { build_settings.save }

  default_scope { order('id DESC') }

  STAGES = {
    1 => { name: 'Введение в процедуру', description: 'Знакомство с описанием ситуации и ее различных аспектов',
           type_stage: :aspect_posts,  active: true,
           substages: {
             0 => { name: 'Изучение и обсуждение БЗ', active: true, code: :aspects_esimate },
             1 => { name: 'Расширенная БЗ', active: true, code: :aspects_learn },
             2 => { name: 'Голосование за аспекты', active: true, code: :aspects_voting }
           }
    },
    2 => { name: 'Анализ ситуации', description: 'Выявление проблем текущей ситуации', type_stage: :discontent_posts, active: true,
           substages: {
             0 => { name: 'Поиск несовершенств', active: true, code: :discontents_add },
             1 => { name: 'Голосование', active: true, code: :discontents_voting }
           }
    },
    3 => { name: 'Сбор идей', description: 'Поиск идей по устранению проблем текущей ситуации', type_stage: :concept_posts, active: true,
           substages: {
             0 => { name: 'Поиск идей', active: true, code: :concepts_add },
             1 => { name: 'Голосование', active: true, code: :discontents_voting }
           }
    },
    4 => { name: 'Объединение идей в пакеты', description: 'Объединение идей в пакеты', type_stage: :novation_posts, active: true,
           substages: {
             0 => { name: 'Создание пакетов', active: true, code: :novations_add },
             1 => { name: 'Голосование', active: true, code: :novations_voting }
           }
    },
    5 => { name: 'Проектное предложение', description: 'Формирование проектных предложений на основе пакетов идей',
           type_stage: :plan_posts, active: true,
           substages: {
             0 => { name: 'Создание проектных предложений', active: true, code: :plans_add },
             1 => { name: 'Голосование', active: true, code: :plans_voting }

           }
    },
    6 => { name: 'Подведение итогов', description: 'Оценка проектов', type_stage: :estimate_posts, active: true
    },
    7 => { name: 'Завершение процедуры', description: 'Завершение процедуры', type_stage: :completion_proc_posts, active: true
    }
  }.freeze

  TYPE_ACCESS = {
    opened: { name: I18n.t('form.project.opened'), code: 0 },
    club: { name: I18n.t('form.project.club'), code: 1 },
    closed: { name: I18n.t('form.project.closed'), code: 2 }
  }.freeze

  validates :name, presence: true

  def set_position_for_aspects
    aspect = Aspect::Post.where(project_id: self, status: 0).first
    return if aspect.position
    aspects = Aspect::Post.scope_vote_top(id, '0')
    aspects.each do |asp|
      asp.update_attributes(position: asp.voted_users.size)
    end
  end

  def concept_comments
    Concept::Comment.joins('INNER JOIN concept_posts ON concept_comments.post_id = concept_posts.id')
      .where('concept_posts.project_id = ?', id)
  end

  def discontent_comments
    Discontent::Comment.joins('INNER JOIN discontent_posts ON discontent_comments.post_id = discontent_posts.id')
      .where('discontent_posts.project_id = ?', id)
  end

  def stages
    STAGES
  end
end
