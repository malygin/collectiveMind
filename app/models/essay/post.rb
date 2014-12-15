class Essay::Post < ActiveRecord::Base
  include BasePost
  scope :by_stage, ->(p) { where(stage: p) }
end
