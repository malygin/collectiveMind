class ModeratorMessage < ActiveRecord::Base
  #@todo remove
  attr_accessible :message
  belongs_to :user

  scope :recent, -> { last(15) }

  def time
    Russian::strftime(created_at, '%k:%M:%S')
  end
end
