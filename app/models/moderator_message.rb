class ModeratorMessage < ActiveRecord::Base
  #@todo remove
  attr_accessible :message
  belongs_to :user
end
