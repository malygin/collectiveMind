module BasePostVoting
  extend ActiveSupport::Concern
  included do
    belongs_to :user
    belongs_to :post
  end
end
