class LifeTape::Voiting < ActiveRecord::Base
  attr_accessible  :user, :discontent_aspect
  belongs_to :user
  belongs_to :discontent_aspect
end
