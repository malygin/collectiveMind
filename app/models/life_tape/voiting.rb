class LifeTape::Voiting < ActiveRecord::Base
  belongs_to :user
  belongs_to :core_aspect
end
