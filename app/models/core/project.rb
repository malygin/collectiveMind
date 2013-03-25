class Core::Project < ActiveRecord::Base
##### status 
# 0 - prepare to procedure
# 1 - life_tape
# 2 - vote fo aspects
# 3 - Discontent
# 4 - voting for Discontent
# 5 - Concept 
# 6 - voiting for Concept
# 7 - plan
# 8 - voiting for plan
# 9 - estimate
# 10 - final vote
# 11 - wait for decision
# 20  - complete
####### type_access
# 0 open for everyone and everyone may be participant
# 1 open for everyone but participant may be only with rights
# 2  closed, only for participant

  attr_accessible :desc, :name, :short_desc, :status, :type_access, :url_logo

  has_many :life_tape_posts, :class_name => "LifeTape::Post"
  has_many :aspects, :class_name => "Discontent::Aspect"
end
