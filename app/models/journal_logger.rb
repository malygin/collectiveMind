class JournalLogger < ActiveRecord::Base

  belongs_to :user
  belongs_to :user_informed, class_name: 'User', foreign_key: :user_informed
  belongs_to :project, class_name: 'Core::Project', foreign_key: 'project_id'

  default_scope {  order 'created_at DESC' }
  scope :select_users_for_news, -> user { where(user: user) }
  scope :type_event, -> type_event { where(type_event: type_event) if type_event.present? }
  scope :date_begin, -> date_begin { where("DATE(journal_loggers.created_at + time '04:00') >= ?", date_begin) if date_begin.present? }
  scope :date_end, -> date_end { where("DATE(journal_loggers.created_at + time '04:00') <= ?", date_end) if date_end.present? }

  scope :by_project, -> project { where(journal_loggers: {project: project}) }

  scope :created_order, -> { order("journal_loggers.created_at DESC") }
  scope :active_proc, -> { where("core_projects.status < ?", 20) }
  scope :not_moderators, -> { joins(:user).where('users.type_user is null') }
  scope :for_moderators, -> { joins(:user).where('users.type_user in (?)', [1]) }

  validates :body, :type_event, :project_id, presence: true

  # new methods
  def self.events_for_all(list_type, closed_projects)
    JournalLogger.joins(:project).active_proc.where("core_projects.type_access IN (?) OR core_projects.id IN (?)", list_type, closed_projects)
  end

  def self.events_for_all_prime
    JournalLogger.joins(:project).active_proc
  end

  def self.events_for_project(project_id)
    JournalLogger.joins(:project).where('project_id = ?', project_id).active_proc
  end

  # older methods
  def self.events_for_user_feed(project_id)
    JournalLogger.where(' project_id = ? AND personal = ? ', project_id, false)
  end

  def self.events_for_user_show(project_id, user_id, lim = 5)
    JournalLogger.where(' project_id = ? AND personal =? ', project_id, false).where("user_id= (?)", user_id).limit(lim)
  end

  def self.events_for_my_feed(project_id, user_id)
    JournalLogger.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =?', project_id, user_id, false, true)
  end

  def self.events_for_content(project_id, user_id, first_id)
    JournalLogger.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =? AND first_id=?', project_id, user_id, false, true, first_id)
  end

  def self.events_for_comment(project_id, user_id, first_id, second_id)
    JournalLogger.where(' project_id = ? AND user_informed = ? AND viewed = ? AND personal = ? AND first_id = ? AND second_id = ?', project_id, user_id, false, true, first_id, second_id)
  end

  def self.last_event_for(user, project_id)
    JournalLogger.where(' project_id = ? AND personal = ? ', project_id, false).where("user_id= (?)", user.id).first
  end

end
