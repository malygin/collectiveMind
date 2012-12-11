class Concept::TaskSupplyPair < ActiveRecord::Base
  attr_accessible :order, :post, :supply, :task
  belongs_to :post
end
