class Journal < ActiveRecord::Base
  include Filterable

  attr_accessible :body, :body2, :type_event, :user, :project, :user_informed, :viewed,
                  :event, :first_id, :second_id, :personal
  belongs_to :user
  belongs_to :user_informed, class_name: 'User', foreign_key: :user_informed

  belongs_to :project, class_name: 'Core::Project', foreign_key: 'project_id'

  def self.select_type_content(type_content)
    case type_content
      when "by_comment"
               ["life_tape_comment_save","my_life_tape_comment","discontent_comment_save","my_discontent_comment",
                 "concept_comment_save","my_concept_comment","plan_comment_save","my_plan_comment","essay_comment_save","my_essay_comment",
                 "life_tape_comment_discuss_stat","my_life_tape_comment_discuss_stat","life_tape_comment_approve_status","my_life_tape_comment_approve_status","discontent_comment_discuss_stat","my_discontent_comment_discuss_stat",
                 "discontent_comment_approve_status","my_discontent_comment_approve_status","concept_comment_discuss_stat","my_concept_comment_discuss_stat","concept_comment_approve_status","my_concept_comment_approve_status",
                 "plan_comment_discuss_stat","my_plan_comment_discuss_stat","plan_comment_approve_status","my_plan_comment_approve_status","essay_comment_discuss_stat","my_essay_comment_discuss_stat","essay_comment_approve_status","my_essay_comment_approve_status"
                ]
      when "by_content"
       ["life_tape_post_save","discontent_post_save","concept_post_save","plan_post_save","essay_post_save"] |
       ["discontent_post_update","concept_post_update","plan_post_update","essay_post_update"]
      when "by_note"
        ["my_discontent_note","my_concept_note","my_plan_note"]
    end
  end

  # scope :by_project, -> project { where(:project => project) }
  scope :select_users_for_news, -> user { where(:user => user) }
  # scope :by_note, -> { where(:type_event => note) }

  # scope :by_comment, -> { where(:type_event => comment) }

  # scope :by_content, -> { where(:type_event => content_add | content_edit) }
  # scope :by_content_add, -> { where(:type_event => content_add) }
  # scope :by_content_edit, -> { where(:type_event => content_edit) }

  scope :type_content, -> type_content { where(:type_event => self.select_type_content(type_content)) if type_content != '' and type_content != "content_all" }

  # scope :today, -> { where('DATE(created_at) = ?',  Time.zone.now.utc.to_date) }
  # scope :yesterday, -> { where('DATE(created_at) = ?', Time.zone.now.utc.to_date - 1) }
  # scope :older, -> { where('DATE(created_at) < ?', Time.zone.now.utc.to_date - 1) }

  # scope :by_period, -> date_begin, date_end, date_all { where("DATE(journals.created_at + time '04:00') BETWEEN ? AND ?", ((date_begin.present? and date_all.nil?) ? date_begin : '1900-01-01'), ((date_end.present? and date_all.nil?) ? date_end : '2100-01-01')) }

  scope :date_begin, -> date_begin { where("DATE(journals.created_at + time '04:00') >= ?", date_begin.present? ? date_begin : '1900-01-01') }
  scope :date_end, -> date_end { where("DATE(journals.created_at + time '04:00') <= ?", date_end.present? ? date_end : '2100-01-01') }


  @types = []
  @my_types = [11]

  def self.events_for_all(list_type, closed_projects, events_ignore, lim = 1000)
    Journal.joins("INNER JOIN core_projects ON journals.project_id = core_projects.id").where("(core_projects.type_access IN (#{list_type.join(", ")}) OR core_projects.id IN (#{closed_projects.join(", ")})) AND journals.type_event NOT IN (#{events_ignore.join(', ')})").where("core_projects.status < 12").limit(lim).order('journals.created_at DESC')
  end

  def self.events_for_all_prime(events_ignore, lim = 1000)
    Journal.joins("INNER JOIN core_projects ON journals.project_id = core_projects.id").where("type_event NOT IN (#{events_ignore.join(', ')})").where("core_projects.status < 12").limit(lim).order('created_at DESC')
  end

  def self.events_for_project(project_id, events_ignore, lim = 1000)
    Journal.joins("INNER JOIN core_projects ON journals.project_id = core_projects.id").where('project_id = ?', project_id).where("type_event NOT IN (#{events_ignore.join(', ')})").where("core_projects.status < 12").order('created_at DESC')
  end

  def self.events_for_aspect(project_id, aspect_id, events_ignore, lim = 1000)
    Journal.joins("INNER JOIN core_projects ON journals.project_id = core_projects.id").where('project_id = ?', project_id).where("type_event NOT IN (#{events_ignore.join(', ')})").where("core_projects.status < 12").order('created_at DESC')
  end

  def self.events_for_user_feed(project_id, lim = 5)
    Journal.where(' project_id = ? AND personal = ? ', project_id, false).order('created_at DESC')
  end

  def self.events_for_user_show(project_id, user_id, lim = 5)
    Journal.where(' project_id = ? AND personal =? ', project_id, false).where("user_id= (?)", user_id).limit(lim).order('created_at DESC')
  end

  def self.events_for_my_feed(project_id, user_id, lim=10)
    Journal.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =?', project_id, user_id, false, true).order('created_at DESC')
  end

  def self.events_for_content(project_id, user_id, first_id)
    Journal.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =? AND first_id=?', project_id, user_id, false, true, first_id).order('created_at DESC')
  end

  def self.last_event_for(user, project_id)
    Journal.where(' project_id = ? AND personal = ? ', project_id, false).where("user_id= (?)", user.id).order('created_at DESC').first
  end

  def self.events_for_transfer_comment(project, comment, aspect_old_id, aspect_id)
    self.journal_comment_update(project, comment, aspect_old_id, aspect_id)
    unless comment.comments.nil?
      comment.comments.each do |c|
        self.journal_comment_update(project, c, aspect_old_id, aspect_id)
      end
    end
  end

  def self.destroy_comment_journal(project, comment)
    where(:project_id => project.id, :user_id => comment.user, :second_id => comment.id).destroy_all
  end

  private
  def self.journal_comment_update(project, comment, aspect_old_id, aspect_id)
    journal_comment = self.where(type_event: 'life_tape_comment_save', project_id: project.id, user_id: comment.user, first_id: aspect_old_id, second_id: comment.id).first
    my_journal_comment = self.where(type_event: 'my_life_tape_comment', project_id: project.id, user_id: comment.user, first_id: aspect_old_id, second_id: comment.id).first
    reply_journal_comment = self.where(type_event: 'reply_life_tape_comment', project_id: project.id, user_id: comment.user, first_id: aspect_old_id, second_id: comment.id).first
    journal_comment.update_attributes(first_id: aspect_id) unless journal_comment.nil?
    my_journal_comment.update_attributes(first_id: aspect_id) unless my_journal_comment.nil?
    reply_journal_comment.update_attributes(first_id: aspect_id) unless reply_journal_comment.nil?
  end
end
