module BasePostVoting
  extend ActiveSupport::Concern
  included do
    belongs_to :user
    belongs_to :post
    validates :user_id, :post_id, presence: true
  end
end
