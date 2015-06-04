module BaseCommentVoting
  extend ActiveSupport::Concern
  included do
    belongs_to :user
    belongs_to :comment
  end
end
