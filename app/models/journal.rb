class Journal < ActiveRecord::Base
  attr_accessible :body, :body2, :type_event, :user, :project, :user_informed, :viewed,
                  :event, :first_id, :second_id, :personal
  belongs_to :user
  belongs_to :user_informed, class_name: 'User', foreign_key: :user_informed

  belongs_to :project, :class_name => 'Core::Project', :foreign_key => "project_id"
  @types = []
  @my_types = [11]

  def self.events_for_user_feed(project_id, lim = 5)
		Journal.where(' project_id = ? AND personal = ? ',project_id, false).order('created_at DESC')
  end

  def self.events_for_user_show(project_id, user_id, lim = 5)
		Journal.where(' project_id = ? AND personal =? ',project_id, false).where("user_id= (?)", user_id).limit(lim).order('created_at DESC')
  end

  def self.events_for_my_feed(project_id, user_id, lim=10)
    Journal.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =?',project_id,  user_id, false, true).order('created_at DESC')
  end

  def self.events_for_content(project_id, user_id, first_id)
    Journal.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =? AND first_id=?',project_id,  user_id, false, true, first_id).order('created_at DESC')
  end

  def self.last_event_for(user, project_id)
    Journal.where(' project_id = ? AND personal = ? ',project_id, false).where("user_id= (?)", user.id).order('created_at DESC').first

  end

  def self.events_for_transfer_comment(project, comment, aspect_old_id, aspect_id)
    self.journal_comment_update(project, comment, aspect_old_id, aspect_id)
    unless comment.comments.nil?
      comment.comments.each do |c|
        self.journal_comment_update(project, c, aspect_old_id, aspect_id)
      end
    end
  end

  private
    def self.journal_comment_update(project, comment, aspect_old_id, aspect_id)
      journal_comment = self.where(:type_event => 'life_tape_comment_save', :project_id => project.id, :user_id => comment.user, :first_id => aspect_old_id, :second_id => comment.id).first
      my_journal_comment = self.where(:type_event => 'my_life_tape_comment', :project_id => project.id, :user_id => comment.user, :first_id => aspect_old_id, :second_id => comment.id).first
      reply_journal_comment = self.where(:type_event => 'reply_life_tape_comment', :project_id => project.id, :user_id => comment.user, :first_id => aspect_old_id, :second_id => comment.id).first
      journal_comment.update_attributes(first_id: aspect_id) unless journal_comment.nil?
      my_journal_comment.update_attributes(first_id: aspect_id) unless my_journal_comment.nil?
      reply_journal_comment.update_attributes(first_id: aspect_id) unless reply_journal_comment.nil?
    end

end
