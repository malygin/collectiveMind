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
		Journal.where(' project_id = ? AND type_event NOT IN (?)',project_id, @types).where("user_id= (?)", user_id).limit(lim).order('created_at DESC')
  end

  def self.events_for_my_feed(project_id, user_id, lim=10)
    Journal.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =?',project_id,  user_id, false, true).order('created_at DESC')
  end

  def self.events_for_content(project_id, user_id, first_id)
    Journal.where(' project_id = ? AND user_informed = ? AND viewed =? AND personal =? AND first_id=?',project_id,  user_id, false, true, first_id).order('created_at DESC')
  end



  def self.last_event_for(user, project_id)
    Journal.where(' project_id = ? AND type_event NOT IN (?)',project_id, @my_types).where("user_id= (?)", user.id).order('created_at DESC').first

  end


end
