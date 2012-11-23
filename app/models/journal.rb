class Journal < ActiveRecord::Base
  attr_accessible :body, :type_event, :user
  belongs_to :user
end
