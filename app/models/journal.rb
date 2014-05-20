class Journal < ActiveRecord::Base
  attr_accessible :body, :type_event, :user, :project, :user_informed, :viewed
  belongs_to :user
  belongs_to :user_informed, class_name: 'User', foreign_key: :user_informed

  belongs_to :project, :class_name => 'Core::Project', :foreign_key => "project_id"
  @types = %w(enter)
  @my_types = %w(my_life_tape_comment my_discontent_comment my_concept_comment my_discontent_note my_concept_note)

  def self.events_for_user_feed(project_id, lim = 10)
		Journal.where(' project_id = ? AND type_event NOT  IN (?)',project_id, @types+ @my_types).limit(lim).order('created_at DESC')
  end

  def self.events_for_user_show(project_id, user_id, lim = 9)
		Journal.where(' project_id = ? AND type_event NOT IN (?)',project_id, @types).where("user_id= (?)", user_id).limit(lim).order('created_at DESC')
  end

  def self.events_for_my_feed(project_id, user_id, lim=9)
    Journal.where(' project_id = ? AND type_event  IN (?) AND user_informed = ?',project_id, @my_types, user_id).limit(lim).order('created_at DESC')
  end

  def self.count_events_for_my_feed(project_id, user_id)
    Journal.where(' project_id = ? AND type_event  IN (?) AND user_informed = ? AND viewed=?',project_id, @my_types, user_id, false).size
  end


end
