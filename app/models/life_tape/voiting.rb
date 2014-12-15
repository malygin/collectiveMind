class LifeTape::Voiting < ActiveRecord::Base
  belongs_to :user
  belongs_to :discontent_aspect
end
