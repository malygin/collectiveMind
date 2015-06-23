class Journal < ActiveRecord::Base
  include Util::Renderable
  include Util::Filterable
  # extend ApplicationHelper
  # extend MarkupHelper

  belongs_to :user
  belongs_to :user_informed, class_name: 'User', foreign_key: :user_informed
  belongs_to :project, class_name: 'Core::Project', foreign_key: 'project_id'

  default_scope { where("type_event != 'visit_save'") }
  scope :select_users_for_news, -> user { where(user: user) }
  scope :date_begin, -> date_begin { where("DATE(journals.created_at + time '04:00') >= ?", date_begin) if date_begin.present? }
  scope :date_end, -> date_end { where("DATE(journals.created_at + time '04:00') <= ?", date_end) if date_end.present? }

  scope :by_project, -> project { where(journals: { project: project }) }
  scope :events_ignore, -> events_ignore { where.not(journals: { type_event: events_ignore }) }
  scope :created_order, -> { order('journals.created_at DESC') }
  scope :active_proc, -> { where('core_projects.status < ?', 20) }
  scope :not_moderators, -> { joins(:user).where('users.type_user is null') }
  scope :for_moderators, -> { joins(:user).where('users.type_user in (?)', [1]) }

  scope :auto_feed_mailer, lambda {
    joins("LEFT OUTER JOIN user_checks ON journals.user_informed = user_checks.user_id AND
             journals.project_id = user_checks.project_id AND user_checks.check_field = 'auto_feed_mailer'")
      .where(user_checks: { status: ['f', nil] })
  }

  validates :type_event, :project_id, presence: true

  def self.events_ignore_list
    %w(reply_life_tape_comment reply_discontent_comment reply_concept_comment reply_plan_comment reply_essay_comment)
  end

  # scheduler_mailer
  def self.events_for_user_mailer(date, users)
    Journal.auto_feed_mailer.where('viewed = ? AND personal = ?', false, true).where(user_informed: users)
      .where('journals.created_at >= ?', date).order('journals.created_at DESC')
  end

  def self.events_for_my_feed(project_id, user_id)
    Journal.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =?', project_id, user_id, false, true)
      .order('created_at DESC')
  end

  def self.events_for_my_feed_viewed(project_id, user_id, lim = 10)
    Journal.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =?', project_id, user_id, true, true)
      .limit(lim).order('created_at DESC')
  end

  def self.destroy_comment_journal(project, comment)
    where(project_id: project.id, user_id: comment.user, second_id: comment.id).destroy_all
  end

  def self.destroy_journal_record(project, type_event, user_informed, post, personal)
    where(project_id: project.id, type_event: type_event, user_informed: user_informed, first_id: post.id, personal: personal).destroy_all
  end
end
