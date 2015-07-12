class JournalLogger < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_informed, class_name: 'User', foreign_key: :user_informed
  belongs_to :project, class_name: 'Core::Project', foreign_key: 'project_id'

  default_scope {  order 'created_at DESC' }
  scope :select_users_for_news, -> user { where(user: user) }
  scope :by_type_event, -> type_event { where(journal_loggers: { type_event: type_event }) if type_event.present? }
  scope :date_begin, -> date_begin { where("DATE(journal_loggers.created_at + time '04:00') >= ?", date_begin) if date_begin.present? }
  scope :date_end, -> date_end { where("DATE(journal_loggers.created_at + time '04:00') <= ?", date_end) if date_end.present? }

  scope :by_project, -> p { where(journal_loggers: { project_id: p }) }

  scope :created_order, -> { order('journal_loggers.created_at DESC') }
  scope :active_proc, -> { where('core_projects.status < ?', 20) }
  scope :not_moderators, -> { joins(:user).where('users.type_user is null') }
  scope :for_moderators, -> { joins(:user).where('users.type_user in (?)', [1]) }

  validates :body, :type_event, :project_id, presence: true
end
