module BasePost
  extend ActiveSupport::Concern
  include Util::Filterable

  # Статусы поста: черновик, опубликовано, одобрено, в архиве
  STATUSES = {
      draft: 0,
      published: 1,
      approved: 2,
      archived: 3
  }.freeze

  SCORE = 10

  included do
    belongs_to :user
    belongs_to :project, class_name: 'Core::Project'
    has_many :notes
    has_many :comments

    has_many :post_votings
    has_many :users, through: :post_votings

    has_many :post_votings_pro, -> { joins(:post_votings).where("#{table_name}.against = ?", false) }, class_name: 'PostVoting'
    has_many :users_pro, through: :post_votings_pro, source: :user

    has_many :post_votings_against, -> { joins(:post_votings).where("#{table_name}.against = ?", true) }, class_name: 'PostVoting'
    has_many :users_against, through: :post_votings_against, source: :user

    has_many :admins_pro, -> { where users: {type_user: [1, 6]} }, through: :post_votings_pro, source: :user
    has_many :admins_vote, -> { where users: {type_user: [1, 6]} }, through: :post_votings, source: :user
    has_many :admins_against, -> { where users: {type_user: [1, 6]} }, through: :post_votings_against, source: :user

    scope :for_project, -> (project) { where(project_id: project) }
    scope :by_user, ->(user) { where(user_id: user.id) }
    scope :for_expert, -> { where(status: 1) }
    scope :accepted, -> { where(status: 2) }
    scope :archive, -> { where(status: 3) }
    scope :with_votes, -> { includes(:post_votings).where('"discontent_post_votings"."id" > 0') }
    scope :with_concept_votes, -> { includes(:post_votings).where('"concept_post_votings"."id" > 0') }

    scope :created_order, -> { reorder("#{table_name}.created_at DESC") }
    scope :updated_order, -> { reorder("#{table_name}.updated_at DESC") }
    scope :popular_posts, -> { order('number_views DESC') }

    scope :date_stage, ->(project) { where("DATE(#{table_name}.created_at) >= ? AND DATE(#{table_name}.created_at) <= ?", project.date_begin_stage(table_name).to_date, project.date_end_stage(table_name).to_date) if project.date_begin_stage(table_name).present? and project.date_end_stage(table_name).present? }

    # скоуп для отбора постов с последнего захода на страницу
    scope :after_last_visit_posts, ->(last_time) { where("#{table_name}.created_at >= ?", last_time) if last_time.present? }
    scope :after_last_visit_comments, ->(last_time) { joins(:comments).where("#{table_name.gsub('_posts', '_comments')}.created_at >= ?", last_time) if last_time.present? }

    validates :user_id, :project_id, presence: true
    validates :status, inclusion: {in: STATUSES.values}

    # вывод постов по дате последних комментов
    def self.sort_comments
      select("#{table_name}.*, max(#{table_name.gsub('_posts', '_comments')}.created_at) as last_date").
          joins("LEFT OUTER JOIN #{table_name.gsub('_posts', '_comments')} ON #{table_name.gsub('_posts', '_comments')}.post_id = #{table_name}.id").
          group("#{table_name}.id").
          reorder("max(#{table_name.gsub('_posts', '_comments')}.created_at) DESC NULLS LAST")
    end

    def last_comment
      self.comments.reorder(created_at: :desc).first
    end

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
        when :collect_info, 'collect_info'
          self.instance_of? CollectInfo::Post
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

    STATUSES.keys.each do |method_name|
      define_method :"#{method_name}?" do
        status == STATUSES[method_name]
      end
    end
  end
end
