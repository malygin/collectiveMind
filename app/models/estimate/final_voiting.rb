class Estimate::FinalVoiting < ActiveRecord::Base
  attr_accessible :post, :score, :user
    belongs_to :user
    belongs_to :post, :class_name => "Plan::Post"
end
