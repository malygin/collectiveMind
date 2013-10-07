module BaseComment  extend ActiveSupport::Concern
  included do
    attr_accessible :content, :user, :censored
    belongs_to :user
    belongs_to :post
    has_many :comment_votings
    has_many :users, :through => :comment_votings
        default_scope :order => 'created_at ASC'

  end
end
