module BaseComment
  extend ActiveSupport::Concern
  include Util::Filterable
  included do
    belongs_to :user
    belongs_to :post

    has_many :comments, foreign_key: 'comment_id'
    belongs_to :comment, foreign_key: 'comment_id'

    has_many :comment_votings
    has_many :users, through: :comment_votings
    default_scope -> { order 'created_at ASC' }

    has_many :comment_votings_pro, -> { joins(:comment_votings).where("#{table_name}.against = ?", false) }, class_name: 'CommentVoting'
    has_many :users_pro, through: :comment_votings_pro, source: :user

    has_many :comment_votings_against, -> { joins(:comment_votings).where("#{table_name}.against = ?", true) }, class_name: 'CommentVoting'
    has_many :users_against, through: :comment_votings_against, source: :user

    has_many :improve_disposts, -> { where improve_stage: [1, 2] }, foreign_key: 'improve_comment',
             source: :discontent_posts, class_name: 'Discontent::Post'
    has_many :improve_concepts, -> { where improve_stage: [1, 2, 3] }, foreign_key: 'improve_comment',
             source: :concept_posts, class_name: 'Concept::Post'

    scope :type_like, -> { where(useful: 't') }

    scope :not_check, -> { where(discontent_status: ['f',nil],concept_status: ['f',nil], discuss_status:['f',nil], approve_status: ['f',nil], useful: ['f',nil]) }

    scope :date_stage, ->(project) { where("DATE(#{table_name}.created_at) >= ? AND DATE(#{table_name}.created_at) <= ?", project.date_begin_stage(table_name).to_date, project.date_end_stage(table_name).to_date) if project.date_begin_stage(table_name).present? and project.date_end_stage(table_name).present? }

    scope :after_last_visit, ->(last_time) { where("#{table_name}.created_at >= ?", last_time) if last_time.present?}

    validates :content, :user_id, :post_id, presence: true

    def get_class
      self.class.name.deconstantize
    end

    def main_comment?
      self.comment_id.nil?
    end

    def controller_name_for_action
      self.post.class.name.underscore.pluralize
    end

    def check_status_for_label(st)
      if st == 'discontent'
        self.discontent_status
      else
        self.concept_status
      end
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
      false
    end

    def stage_name
      self.class.name.deconstantize.underscore
    end
  end
end
