module BaseComment  extend ActiveSupport::Concern
  included do
    attr_accessible :content, :user, :censored, :post_id, :comment_id
    belongs_to :user
    belongs_to :post

    has_many :comments, :class_name => 'LifeTape::Comment', :foreign_key => 'comment_id'
    belongs_to :comment, :class_name => 'LifeTape::Comment', :foreign_key => 'comment_id'

    has_many :comment_votings
    has_many :users, :through => :comment_votings
        default_scope :order => 'created_at ASC'

    has_many :comment_votings_pro,:conditions => ['against = ?',false], :source => :comment_votings, :class_name => 'CommentVoting'
    has_many :users_pro, :through => :comment_votings_pro, :source => :user

    has_many :comment_votings_against,:conditions => ['against = ?',true], :source => :comment_votings, :class_name => 'CommentVoting'
    has_many :users_against, :through => :comment_votings_against, :source => :user

    def get_class
      self.class.name.deconstantize
    end
  end
end
