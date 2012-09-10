class Project < ActiveRecord::Base
  attr_accessible :begin1st, :begin1stvote, :description, :end1st, :end1stvote, :name
  has_many :frustrations
end
