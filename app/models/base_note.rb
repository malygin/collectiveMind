module BaseNote
  extend ActiveSupport::Concern
  included do
    attr_accessible :content, :post, :user, :type_field
    belongs_to :user
    belongs_to :post
    scope :by_type, ->(type) { where(type_field: type) }
  end
end
