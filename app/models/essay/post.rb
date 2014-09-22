class Essay::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :stage, :negative, :positive, :change, :reaction
  scope :by_stage, ->(p) { where(stage: p) }
end
