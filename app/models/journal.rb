class Journal < ActiveRecord::Base
  attr_accessible :body, :type, :user_id
  belongs_to :user
end
