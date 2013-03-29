class Essay::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :stage
end
