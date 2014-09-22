module BaseCommentVoting
  extend ActiveSupport::Concern
  included do
    attr_accessible :comment, :user, :against
    belongs_to :user
    belongs_to :comment
  end
end
