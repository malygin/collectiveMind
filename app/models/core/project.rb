class Core::Project < ActiveRecord::Base
  belongs_to :project_type, class_name: 'Core::ProjectType', foreign_key: :project_type_id

  has_one :settings, class_name: 'Core::ProjectSetting', dependent: :destroy
  accepts_nested_attributes_for :settings

  has_many :aspects, class_name: 'Aspect::Post'
  has_many :aspects_for_discussion, -> { where(aspect_id: nil, status: 0) }, class_name: 'Aspect::Post'
  has_many :other_aspects, -> { where(aspect_id: nil, status: 1) }, class_name: 'Aspect::Post'
  has_many :aspect_posts_for_vote, -> { where(aspect_id: nil, status: 0) }, class_name: 'Aspect::Post'

  has_many :discontents, class_name: 'Discontent::Post'
  has_many :discontents_for_discussion, -> { where status: [0, 1] }, class_name: 'Discontent::Post'
  has_many :discontent_posts_for_vote, -> { where status: [0, 1] }, class_name: 'Discontent::Post'
  has_many :discontents_approved, -> { where status: 2 }, class_name: 'Discontent::Post'

  has_many :concepts, class_name: 'Concept::Post'
  has_many :concepts_for_discussion, -> { where status: [0, 1] }, class_name: 'Concept::Post'
  has_many :concept_posts_for_vote, -> { where status: [0, 1] }, class_name: 'Concept::Post'

  has_many :novations, class_name: 'Novation::Post'
  has_many :novations_for_discussion, -> { where status: 1 }, class_name: 'Novation::Post'
  has_many :novation_posts_for_vote, -> { where status: 1 }, class_name: 'Novation::Post'

  has_many :plans, class_name: 'Plan::Post'
  has_many :plans_for_discussion, -> { where status: 1 }, class_name: 'Plan::Post'
  has_many :plans_approved, -> { where status: 2 }, class_name: 'Plan::Post'

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
    1 => { name: I18n.t('stages.intro'), description: I18n.t('stages.intro_desc'), type_stage: :aspect_posts, title_stage: :aspect,
           substages: {
             0 => { name: I18n.t('stages.intro1'), active: true, code: :aspects_esimate, status: :add },
             1 => { name: I18n.t('stages.intro2'), active: true, code: :aspects_learn, status: :add },
             2 => { name: I18n.t('stages.intro3'), active: true, code: :aspects_voting, status: :vote }
           },
           folders: {
             0 => { role: 'all', type_poll: 1 },
             1 => { role: 'important', type_poll: 2 },
             2 => { role: 'not_important', type_poll: 3 },
             3 => { role: 'unnecessary', type_poll: 4 }
           }
    },
    2 => { name: I18n.t('stages.discontent'), description: I18n.t('stages.discontent_desc'), type_stage: :discontent_posts, title_stage: :discontent,
           substages: {
             0 => { name: I18n.t('stages.discontent1'), active: true, code: :discontents_add, status: :add },
             1 => { name: I18n.t('stages.discontent2'), active: true, code: :discontents_voting, status: :vote }
           },
           folders: {
             0 => { role: 'all', type_poll: 5 },
             1 => { role: 'important', type_poll: 1 },
             2 => { role: 'not_important', type_poll: 2 },
             3 => { role: 'necessary', type_poll: 3 },
             4 => { role: 'unnecessary', type_poll: 4 }
           }
    },
    3 => { name: I18n.t('stages.concept'), description:  I18n.t('stages.concept_desc'), type_stage: :concept_posts, title_stage: :concept,
           substages: {
             0 => { name: I18n.t('stages.concept1'), active: true, code: :concepts_add, status: :add },
             1 => { name: I18n.t('stages.concept2'), active: true, code: :discontents_voting, status: :vote }
           },
           folders: {
             0 => { role: 'all', type_poll: 1 },
             1 => { role: 'vote_yes', type_poll: 3 },
             2 => { role: 'vote_no', type_poll: 4 }
           }
    },
    4 => { name: I18n.t('stages.novation'), description:  I18n.t('stages.novation_desc'), type_stage: :novation_posts, title_stage: :novation,
           substages: {
             0 => { name: I18n.t('stages.novation1'), active: true, code: :novations_add, status: :add },
             1 => { name: I18n.t('stages.novation2'), active: true, code: :novations_voting, status: :vote }
           },
           folders: {
             0 => { role: 'all', type_poll: 1 },
             1 => { role: 'vote_yes', type_poll: 3 },
             2 => { role: 'vote_no', type_poll: 4 }
           }
    },
    5 => { name: I18n.t('stages.plan'), description:  I18n.t('stages.plan_desc'), type_stage: :plan_posts, title_stage: :plan,
           substages: {
             0 => { name: I18n.t('stages.plan1'), active: true, code: :plans_add, status: :add }
           }
    },
    6 => { name: I18n.t('stages.estimate'), description:  I18n.t('stages.estimate_desc'), type_stage: :estimate_posts, title_stage: :estimate
    },
    7 => { name: I18n.t('stages.result'), description:  I18n.t('stages.result_desc'), type_stage: :completion_posts, title_stage: :completion
    }
  }.freeze

  TYPE_ACCESS = {
    opened: { name: I18n.t('form.project.opened'), code: 0 },
    club: { name: I18n.t('form.project.club'), code: 1 },
    closed: { name: I18n.t('form.project.closed'), code: 2 }
  }.freeze

  validates :name, presence: true

  def stages
    STAGES
  end
end
