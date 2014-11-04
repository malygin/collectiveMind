class ModeratorMessage < ActiveRecord::Base
  #@todo remove
  attr_accessible :message
  belongs_to :user

  default_scope { order(created_at: :desc) }
  scope :recent, -> { limit(10) }

  def time
    Russian::strftime(created_at, '%k:%M:%S')
  end
end
