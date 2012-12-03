class Voiting < ActiveRecord::Base
  attr_accessible  :score, :user
  belongs_to :user
  belongs_to :frustration
end
