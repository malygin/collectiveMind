class Journal < ActiveRecord::Base
  attr_accessible :body, :type_event, :user, :project
  belongs_to :user
  belongs_to :project, :class_name => 'Core::Project', :foreign_key => "project_id"
  @types = %w(enter)

  def self.events_for_user_feed(project_id, lim = 20)
		Journal.where(' project_id = ? AND type_event NOT  IN (?)',project_id, @types).limit(lim).order('created_at DESC')
  end

  def self.events_for_user_show(project_id, user_id, lim = 9)
		Journal.where(' project_id = ? AND type_event NOT IN (?)',project_id, @types).where("user_id= (?)", user_id).limit(lim).order('created_at DESC')
  end

end
