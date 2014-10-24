module BasePost
  extend ActiveSupport::Concern
  include Filterable
  included do
    # status 0 - new, 1 -post expert, 2 - expeted, 3- archive
    attr_accessible :content, :status, :number_views, :user, :project, :censored, :useful
    belongs_to :user
    belongs_to :project, class_name: 'Core::Project'
    has_many :notes
    has_many :comments

    has_many :post_votings
    has_many :users, through: :post_votings

    scope :post_votings_pro, -> { joins(:post_votings).where('post_votings.against = ?', false) }
    has_many :users_pro, through: :post_votings_pro, source: :user

    scope :post_votings_against, -> { joins(:post_votings).where('post_votings.against = ?', true) }
    has_many :users_against, through: :post_votings_against, source: :user

    has_many :admins_pro, -> { where users: {type_user: [1, 6]} }, through: :post_votings_pro, source: :user
    has_many :admins_vote, -> { where users: {type_user: [1, 6]} }, through: :post_votings, source: :user
    has_many :admins_against, -> { where users: {type_user: [1, 6]} }, through: :post_votings_against, source: :user

    scope :for_project, -> (project) { where(project_id: project) }
    scope :for_expert, -> { where(status: 1) }
    scope :accepted, -> { where(status: 2) }
    scope :archive, -> { where(status: 3) }
    scope :with_votes, -> { includes(:post_votings).where('"discontent_post_votings"."id" >0') }
    scope :with_concept_votes, -> { includes(:post_votings).where('"concept_post_votings"."id" >0') }

    scope :created_order, -> { order("#{table_name}.created_at DESC") }
    scope :updated_order, -> { order("#{table_name}.updated_at DESC") }
    scope :popular_posts, -> { order('number_views DESC') }

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

    def main_comments
      self.comments.where(comment_id: nil)
    end

    def get_class
      self.class.name.deconstantize
    end

    def current_class?(stage)
      case stage
        when :life_tape, 'life_tape'
          self.instance_of? LifeTape::Post
        when :discontent, 'discontent'
          self.instance_of? Discontent::Post
        when :concept, 'concept'
          self.instance_of? Concept::Post
        when :plan, 'plan'
          self.instance_of? Plan::Post
        when :estimate, 'estimate'
          self.instance_of? Estimate::Post
        else
          false
      end
    end

    def stage_name
      self.class.name.deconstantize.underscore
    end

    def post_notes(type_field)
      self.notes.by_type(type_field)
    end

    def note_size?(type_field)
      self.post_notes(type_field).size > 0
    end
  end
end
