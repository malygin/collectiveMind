class Discontent::Post < ActiveRecord::Base
  include PostBase
  attr_accessible :when, :where
end
