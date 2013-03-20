class Discontent::Aspect < ActiveRecord::Base
  include BasePost
  attr_accessible :position 
end
