module BasePost  extend ActiveSupport::Concern
  included do
    attr_accessible :content, :status, :number_views, :user
    belongs_to :user
    belongs_to :project, :class_name => "Core::Project"
    has_many :comments
 	has_many :post_voitings
 	has_many :users, :through => :post_voitings
  end
end
