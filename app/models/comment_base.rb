module CommentBase  extend ActiveSupport::Concern
  included do
    attr_accessible :content
    belongs_to :user
    belongs_to :post
  end
end
