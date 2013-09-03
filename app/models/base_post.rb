module BasePost  extend ActiveSupport::Concern
  included do
  	# status 0 - new, 1 -post expert, 2 - expeted, 3- archive
    attr_accessible :content, :status, :number_views, :user, :project, :number_views
    belongs_to :user
    belongs_to :project, :class_name => "Core::Project"
    has_many :post_notes
    has_many :comments
   	has_many :post_votings
   	has_many :users, :through => :post_votings
 
 	  validates :content, :presence => true
    default_scope  :order => 'created_at DESC'

    def show_content
    	content
  	end

 

  end
end
