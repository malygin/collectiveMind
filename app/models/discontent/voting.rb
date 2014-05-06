class Discontent::Voting < ActiveRecord::Base
    attr_accessible :discontent_post, :user, :against
    belongs_to :user
  	belongs_to :discontent_post

    scope :by_positive, ->{where(against: 't')}
    scope :by_negative, ->{where(against: 'f')}
    scope :uniq_user,   ->{select('distinct user_id')}
end
