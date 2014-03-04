module BaseComment  extend ActiveSupport::Concern
  included do
    attr_accessible :content, :user, :censored
    belongs_to :user
    belongs_to :post
    has_many :comment_votings
    has_many :users, :through => :comment_votings
        default_scope :order => 'created_at ASC'

    has_many :comment_votings_pro,:conditions => ['against = ?',false], :source => :comment_votings, :class_name => 'CommentVoting'
    has_many :users_pro, :through => :comment_votings_pro, :source => :user

    has_many :comment_votings_against,:conditions => ['against = ?',true], :source => :comment_votings, :class_name => 'CommentVoting'
    has_many :users_against, :through => :comment_votings_against, :source => :user


  end
end
