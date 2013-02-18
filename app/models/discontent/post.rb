class Discontent::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :when, :where
end
