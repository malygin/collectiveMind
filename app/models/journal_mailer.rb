class JournalMailer < ActiveRecord::Base
  attr_accessible :title, :content, :user, :project, :sent, :viewed,
                  :receiver, :group_id, :status, :visible
  belongs_to :user
  belongs_to :project, class_name: 'Core::Project', foreign_key: 'project_id'

  scope :mailers_for_moderator, ->(user) { where(journal_mailers: {user_id: user.id, status: 0})}
end
