class Discontent::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :when, :where, :aspect_id, :aspect
  belongs_to :aspect
end
