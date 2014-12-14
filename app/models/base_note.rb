module BaseNote
  extend ActiveSupport::Concern
  included do
    belongs_to :user
    belongs_to :post
    scope :by_type, ->(type) { where(type_field: type) }
  end
end
