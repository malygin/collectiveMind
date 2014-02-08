module BasePost  extend ActiveSupport::Concern
  included do
  	# status 0 - new, 1 -post expert, 2 - expeted, 3- archive
    attr_accessible :content, :status, :number_views, :user, :project, :number_views, :censored
    belongs_to :user
    belongs_to :project, :class_name => "Core::Project"
    has_many :post_notes
    has_many :comments
   	has_many :post_votings
   	has_many :users, :through => :post_votings
    scope :for_project, lambda { |project| where(:project_id => project) }
    scope :for_expert, lambda {  where(:status => 1) }
    scope :accepted, lambda {  where(:status => 2) }
    scope :archive, lambda { where(:status => 3) }

    validates :content, :presence => true
    scope :created_order,order("#{table_name}.created_at DESC")
    scope :popular_posts, order('number_views DESC')

    def show_content
    	content
    end

     def self.order_by_param(order)
       if order =='popular'
         popular_posts
       else
         created_order
       end

     end
 

  end
end
