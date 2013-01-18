class Plan::TaskTriplet < ActiveRecord::Base
  attr_accessible :compulsory, :howto, :position,  :supply, :task
  belongs_to :post
  has_many :estimates, :class_name=>'Estimate::TaskTriplet'
end
