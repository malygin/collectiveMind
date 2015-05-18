class Journal < ActiveRecord::Base
  include Util::Renderable
  include Util::Filterable
  extend MarkupHelper

  belongs_to :user
  belongs_to :user_informed, class_name: 'User', foreign_key: :user_informed
  belongs_to :project, class_name: 'Core::Project', foreign_key: 'project_id'

  default_scope { where("type_event != 'visit_save'") }
  scope :select_users_for_news, -> user { where(user: user) }
  scope :type_content, -> type_content { where(type_event: self.select_type_content(type_content)) if type_content.present? and type_content != "content_all" }
  scope :type_event, -> type_event { rewhere(type_event: self.select_type_content(type_event)) if type_event.present? and type_event != "content_all" }
  scope :type_status, -> type_status { where(type_event: self.select_type_content(type_status)) if type_status.present? and type_status != "content_all" }
  scope :date_begin, -> date_begin { where("DATE(journals.created_at + time '04:00') >= ?", date_begin) if date_begin.present? }
  scope :date_end, -> date_end { where("DATE(journals.created_at + time '04:00') <= ?", date_end) if date_end.present? }

  scope :by_project, -> project { where(journals: {project: project}) }
  scope :events_ignore, -> events_ignore { where.not(journals: {type_event: events_ignore})}
  scope :created_order, -> { order("journals.created_at DESC") }
  scope :active_proc, -> { where("core_projects.status < ?", 20) }
  scope :not_moderators, -> { joins(:user).where('users.type_user is null') }
  scope :for_moderators, -> { joins(:user).where('users.type_user in (?)', User::TYPES_USER[:admin]) }

  scope :auto_feed_mailer, -> { joins("LEFT OUTER JOIN user_checks ON journals.user_informed = user_checks.user_id AND journals.project_id = user_checks.project_id AND user_checks.check_field = 'auto_feed_mailer'").where(user_checks: {status: ['f',nil] }) }

  # after_save :send_last_news

  validates :type_event, :project_id, presence: true

  @types = []
  @my_types = [11]

  # new methods
  def self.events_for_all(list_type, closed_projects)
    Journal.joins(:project).active_proc.where("core_projects.type_access IN (?) OR core_projects.id IN (?)",list_type,closed_projects).events_ignore(self.events_ignore_list).created_order
  end

  def self.events_for_all_prime
    Journal.joins(:project).active_proc.events_ignore(self.events_ignore_list).created_order
  end

  def self.events_for_project(project_id)
    Journal.joins(:project).where('project_id = ?', project_id).active_proc.events_ignore(self.events_ignore_list).created_order
  end

  # scheduler_mailer
  def self.events_for_user_mailer(date, users)
    Journal.auto_feed_mailer.where('viewed = ? AND personal = ?', false, true).where(user_informed: users).where("journals.created_at >= ?", date).order('journals.created_at DESC')
  end

  # older methods
  def self.events_for_user_feed(project_id, lim = 5)
    Journal.where(' project_id = ? AND personal = ? ', project_id, false).order('created_at DESC')
  end

  def self.events_for_user_show(project_id, user_id, lim = 5)
    Journal.where(' project_id = ? AND personal =? ', project_id, false).where("user_id= (?)", user_id).limit(lim).order('created_at DESC')
  end

  def self.events_for_my_feed(project_id, user_id, lim=10)
    Journal.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =?', project_id, user_id, false, true).order('created_at DESC')
  end

  def self.events_for_my_feed_viewed(project_id, user_id, lim=10)
    Journal.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =?', project_id, user_id, true, true).limit(lim).order('created_at DESC')
  end

  def self.events_for_content(project_id, user_id, first_id)
    Journal.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =? AND first_id=?', project_id, user_id, false, true, first_id).order('created_at DESC')
  end

  def self.events_for_comment(project_id, user_id, first_id, second_id)
    Journal.where(' project_id = ? AND user_informed = ? AND viewed = ? AND personal = ? AND first_id = ? AND second_id = ?', project_id, user_id, false, true, first_id, second_id).order('created_at DESC')
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
    where(project_id: project.id, user_id: comment.user, second_id: comment.id).destroy_all
  end

  def self.destroy_journal_record(project, type_event, user_informed, post, personal)
    where(project_id: project.id, type_event: type_event, user_informed: user_informed, first_id: post.id, personal: personal).destroy_all
  end

  def self.destroy_journal_award(project, type_event, personal, user, user_informed = nil)
    where(project_id: project.id, type_event: type_event, user_id: user.id, user_informed: user_informed, personal: personal).destroy_all
  end

  private

  def send_last_news
    return if ENV['RAILS_ENV'] == 'test'
    Fiber.new do
      if type_event.start_with? 'my_' and   user_informed
        WebsocketRails.users[user_informed.id].send_message(
            :latest, render_anywhere('application/messages_menu', {current_user: user_informed, project: project,
                                                                   my_journals: user_informed.my_journals(project)}),
            channel: :notifications)
      end
      if type_event != 'visit_save'
        WebsocketRails[:news].trigger :latest_news, render_anywhere('journal/journal', {journal: self, current_user: nil})
      end
    end.resume
  end

  def self.journal_comment_update(project, comment, aspect_old_id, aspect_id)
    journal_comment = self.where(type_event: 'life_tape_comment_save', project_id: project.id, user_id: comment.user, first_id: aspect_old_id, second_id: comment.id).first
    my_journal_comment = self.where(type_event: 'my_life_tape_comment', project_id: project.id, user_id: comment.user, first_id: aspect_old_id, second_id: comment.id).first
    reply_journal_comment = self.where(type_event: 'reply_life_tape_comment', project_id: project.id, user_id: comment.user, first_id: aspect_old_id, second_id: comment.id).first
    journal_comment.update_attributes(first_id: aspect_id) unless journal_comment.nil?
    my_journal_comment.update_attributes(first_id: aspect_id) unless my_journal_comment.nil?
    reply_journal_comment.update_attributes(first_id: aspect_id) unless reply_journal_comment.nil?
  end

  def self.events_ignore_list
    ["reply_life_tape_comment","reply_discontent_comment","reply_concept_comment","reply_plan_comment",
     "reply_essay_comment"]
  end

  def self.select_type_content(type_content)
    case type_content
      when "by_comment"
        ["life_tape_comment_save","my_life_tape_comment","discontent_comment_save","my_discontent_comment",
         "concept_comment_save","my_concept_comment","plan_comment_save","my_plan_comment","essay_comment_save","my_essay_comment",
         "life_tape_comment_discuss_status","my_life_tape_comment_discuss_status","life_tape_comment_approve_status","my_life_tape_comment_approve_status","discontent_comment_discuss_status","my_discontent_comment_discuss_status",
         "discontent_comment_approve_status","my_discontent_comment_approve_status","concept_comment_discuss_status","my_concept_comment_discuss_status","concept_comment_approve_status","my_concept_comment_approve_status",
         "plan_comment_discuss_status","my_plan_comment_discuss_status","plan_comment_approve_status","my_plan_comment_approve_status","essay_comment_discuss_status","my_essay_comment_discuss_status","essay_comment_approve_status","my_essay_comment_approve_status"
        ]
      when "by_content"
        ["life_tape_post_save","discontent_post_save","concept_post_save","plan_post_save","essay_post_save"] |
            ["discontent_post_update","concept_post_update","plan_post_update","essay_post_update"]
      when "by_create"
        ["life_tape_post_save","discontent_post_save","concept_post_save","plan_post_save","essay_post_save"]
      when "by_update"
        ["discontent_post_update","concept_post_update","plan_post_update","essay_post_update"]
      when "by_note"
        ["my_discontent_note","my_concept_note","my_plan_note"]
      when "by_discuss"
        ["life_tape_comment_discuss_status","my_life_tape_comment_discuss_status","discontent_post_discuss_status","my_discontent_post_discuss_status",
         "discontent_comment_discuss_status","my_discontent_comment_discuss_status","concept_post_discuss_status","my_concept_post_discuss_status",
         "concept_comment_discuss_status","my_concept_comment_discuss_status","plan_comment_discuss_status","my_plan_comment_discuss_status",
         "essay_comment_discuss_status","my_essay_comment_discuss_status"]
      when "by_approve"
        ["life_tape_comment_approve_status","my_life_tape_comment_approve_status","discontent_post_approve_status","my_discontent_post_approve_status",
         "discontent_comment_approve_status","my_discontent_comment_approve_status","concept_post_approve_status","my_concept_post_approve_status",
         "concept_comment_approve_status","my_concept_comment_approve_status","plan_comment_approve_status","my_plan_comment_approve_status",
         "essay_comment_approve_status","my_essay_comment_approve_status"]
      when "by_like"
        ["my_add_score_discontent","my_add_score_discontent_improve","add_score_essay","add_score","add_score_anal","add_score_anal_concept_post","my_add_score_comment"]
    end
  end

  def self.comment_event(current_user, project, name_of_comment_for_param, post, comment, comment_answer)
    #@todo новости и информирование авторов
    current_user.journals.build(type_event: name_of_comment_for_param+'_save', project: project,
                                body: "#{trim_content(comment.content)}", body2: trim_content(field_for_journal(post)),
                                first_id: post.id, second_id: comment.id).save!

    if post.user!=current_user
      current_user.journals.build(type_event: 'my_'+name_of_comment_for_param, user_informed: post.user, project: project,
                                  body: "#{trim_content(comment.content)}", body2: trim_content(field_for_journal(post)),
                                  first_id: post.id, second_id: comment.id,
                                  personal: true, viewed: false).save!
    end

    if comment_answer and comment_answer.user!=current_user
      current_user.journals.build(type_event: 'reply_'+name_of_comment_for_param, user_informed: comment_answer.user, project: project,
                                  body: "#{trim_content(comment.content)}", body2: trim_content(comment_answer.content),
                                  first_id: post.id, second_id: comment.id,
                                  personal: true, viewed: false).save!
    end
  end


  def self.like_event(current_user, project, name_of_model_for_param, post, against)
    if post.user!=current_user
      current_user.journals.build(type_event: 'my_'+name_of_model_for_param + (against == 'false' ? '_like' : '_dislike'), user_informed: post.user, project: project,
                                  body: "#{trim_content(post.content)}", first_id: post.id, personal: true, viewed: false).save!
    end
  end

  def self.like_comment_event(current_user, project, name_of_comment_for_param, comment, against)
    if comment.user!=current_user
      current_user.journals.build(type_event: 'my_'+name_of_comment_for_param + (against == 'false' ? '_like' : '_dislike'), user_informed: comment.user, project: project,
                                  body: "#{trim_content(comment.content)}", body2: trim_content(field_for_journal(comment.post)),
                                  first_id: comment.post.id, second_id: comment.id,
                                  personal: true, viewed: false).save!
    end
  end
end
