module BaseComment  extend ActiveSupport::Concern
  included do
    attr_accessible :content, :user
    belongs_to :user
    belongs_to :post
    has_many :comment_voitings
    has_many :users, :through => :comment_voitings
  end
end
