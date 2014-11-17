module BaseComment
  extend ActiveSupport::Concern
  include Filterable
  included do
    attr_accessible :content, :image, :isFile,  :user, :censored, :post_id, :comment_id, :discontent_status, :concept_status, :discuss_status, :useful
    belongs_to :user
    belongs_to :post

    has_many :comments, foreign_key: 'comment_id'
    belongs_to :comment, foreign_key: 'comment_id'

    has_many :comment_votings
    has_many :users, through: :comment_votings
    default_scope -> { order 'created_at ASC' }

    scope :comment_votings_pro, -> { joins(:comment_votings).where('comment_votings.against = ?', false) }
    has_many :users_pro, through: :comment_votings_pro, source: :user

    scope :comment_votings_against, -> { joins(:comment_votings).where('comment_votings.against = ?', true) }
    has_many :users_against, through: :comment_votings_against, source: :user

    has_many :improve_disposts, -> { where improve_stage: [1, 2] }, foreign_key: 'improve_comment',
             source: :discontent_posts, class_name: 'Discontent::Post'
    has_many :improve_concepts, -> { where improve_stage: [1, 2, 3] }, foreign_key: 'improve_comment',
             source: :concept_posts, class_name: 'Concept::Post'

    scope :type_like, -> { where(:useful => 't') }
    scope :type_status, -> type_status {
      if type_status == "by_discuss"
        where(:discuss_status => true)
      elsif type_status == "by_approve"
        where(:approve_status => true)
      elsif type_status == "by_discontent"
        where(:discontent_status => true)
      elsif type_status == "by_concept"
        where(:concept_status => true)
      end
    }
    scope :problem_idea, -> { where("discontent_status = 't' and concept_status = 't'") }
    scope :discuss_approve, -> { where("concept_comments.discuss_status = 't' and concept_comments.approve_status = 't'") }
    scope :not_check, -> { where(discontent_status: ['f',nil],concept_status: ['f',nil], discuss_status:['f',nil], approve_status: ['f',nil], useful: ['f',nil]) }
    scope :date_stage, ->(project) { where("DATE(concept_comments.created_at) >= ? AND DATE(concept_comments.created_at) <= ?", project.date_23.to_date, project.date_34.to_date) if project.date_23.present? and project.date_34.present? }

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
      false
    end

    def stage_name
      self.class.name.deconstantize.underscore
    end
  end
end
