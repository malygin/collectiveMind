class Journal < ActiveRecord::Base
  attr_accessible :body, :type, :user
  belongs_to :user
end
