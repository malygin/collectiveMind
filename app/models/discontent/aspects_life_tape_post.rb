class Discontent::AspectsLifeTapePost < ActiveRecord::Base
  belongs_to :discontent_aspect, class_name: 'Discontent::Aspect'
  belongs_to :life_tape_post, class_name: 'LifeTape::Post'
end
