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
            1 => {name: 'Введение в процедуру', type_stage: :collect_info_posts, cabinet_url: :aspect_posts,  active: true,
                  substages: {
                      0 => {name: 'Оценка и обсуждение аспектов', active: true, code: :aspects_esimate},
                      1 => {name: 'Изучение БЗ', active: true, code: :aspects_learn},
                      2 => {name: 'Голосование за аспекты', active: true, code: :aspects_voting}
                  }
            },
            2 => {name: 'Анализ ситуации', type_stage: :discontent_posts, active: true,
                  substages: {
                      0 => {name: 'Выдвижение несовершенств', active: true, code: :discontents_add},
                      1 => {name: 'Голосование за несовершенства', active: true, code: :discontents_voting},
                  }
            },
            3 => {name: 'Сбор идей', type_stage: :concept_posts, active: true,
                  substages: {
                      0 => {name: 'Выдвижение идей', active: true, code: :concepts_add},
                      1 => {name: 'Голосование за идеи', active: true, code: :discontents_voting},
                  }
            },
            4 => {name: 'Объединение идей в пакеты', type_stage: :novation_posts, active: true,
                  substages: {
                      0 => {name: 'Выдвижение пакетов', active: true, code: :novations_add},
                      1 => {name: 'Голосование за пакеты', active: true, code: :novations_voting},
                  }
            },
            5 => {name: 'Проектное предложение', type_stage: :plan_posts, active: true,
                  substages: {
                      0 => {name: 'Выдвижение проектов', active: true, code: :plans_add},
                      1 => {name: 'Голосование за проекты', active: true, code: :plans_voting},
                  }
            },
            6 => {name: 'Подведение итогов', type_stage: :estimate_posts, active: true,
            },
            7 => {name: 'Завершение процедуры', type_stage: :completion_proc_posts, active: true,
            }
  }.freeze

  TYPE_ACCESS = {
      opened: {name: I18n.t('form.project.opened'), code: 0},
      club: {name: I18n.t('form.project.club'), code: 1},
      closed: {name: I18n.t('form.project.closed'), code: 2},
  }.freeze


  validates :name, presence: true


  def closed?
    type_access == TYPE_ACCESS[:closed][:code]
  end

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

  # return main stage for stage '2:3' it will be 3
  def sub_stage
    stage[2].to_i
  end


  # тип вопроса в зависимости от этапа
  def type_for_questions
    # [STATUS_CODES[:prepare], STATUS_CODES[:collect_info]].include?(self.status) ? self.status : STATUS_CODES[:collect_info]
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
      when 'collect_info'
        self.proc_main_aspects.size - user.voted_aspects.by_project(self.id).size
      when 'discontent'
        self.discontent_for_vote.size - user.voted_discontent_posts.for_project(self.id).size
      when 'concept'
        self.concept_ongoing_post.size - user.voted_concept_post.by_project(self.id).size
      when 'novation'
        self.novations.size - user.voted_novation_post.by_project(self.id).size
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


end
