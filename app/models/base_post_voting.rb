module BasePostVoting
  extend ActiveSupport::Concern
  included do
    attr_accessible :post, :user, :against
    belongs_to :user
    belongs_to :post
  end
end
