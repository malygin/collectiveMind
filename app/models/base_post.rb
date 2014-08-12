module BasePost  extend ActiveSupport::Concern
  included do
  	# status 0 - new, 1 -post expert, 2 - expeted, 3- archive
    attr_accessible :content, :status, :number_views, :user, :project, :censored
    belongs_to :user
    belongs_to :project, :class_name => "Core::Project"
    has_many :post_notes
    has_many :comments

   	has_many :post_votings
   	has_many :users, :through => :post_votings

    has_many :post_votings_pro,:conditions => ['against = ?',false], :source => :post_votings, :class_name => 'PostVoting'
    has_many :users_pro, :through => :post_votings_pro, :source => :user

    has_many :post_votings_against,:conditions => ['against = ?',true], :source => :post_votings, :class_name => 'PostVoting'
    has_many :users_against, :through => :post_votings_against, :source => :user

    has_many :admins_pro, :through => :post_votings_pro, :source => :user,:conditions => {:users => {:type_user => [1,6]}}
    has_many :admins_vote, :through => :post_votings, :source => :user,:conditions => {:users => {:type_user => [1,6]}}

    has_many :admins_against, :through => :post_votings_against, :source => :user ,:conditions => {:users => {:type_user => [1,6]}}

    scope :for_project, lambda { |project| where(:project_id => project) }
    scope :for_expert, lambda {  where(:status => 1) }
    scope :accepted, lambda {  where(:status => 2) }
    scope :archive, lambda { where(:status => 3) }
    scope :with_votes, -> {includes(:post_votings).where('"discontent_post_votings"."id" >0')}
    scope :with_concept_votes, -> {includes(:post_votings).where('"concept_post_votings"."id" >0')}

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
