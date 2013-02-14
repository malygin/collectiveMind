module PostBase  extend ActiveSupport::Concern
  included do
    attr_accessible :content, :status
    belongs_to :user
    has_many :comments

  end
end
