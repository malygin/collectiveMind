module BasePostNote  extend ActiveSupport::Concern
  included do
    attr_accessible :content, :user
    belongs_to :user
    belongs_to :post
  end
end
