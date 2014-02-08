class Discontent::AspectUser < ActiveRecord::Base
  attr_accessible :aspect_id, :user_id
  belongs_to :user
  belongs_to :discontent_aspect, :class_name => 'Discontent::Aspect',:foreign_key => :aspect_id
end
