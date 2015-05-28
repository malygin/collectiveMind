module BaseComment
  extend ActiveSupport::Concern
  include Util::Filterable
  included do
    belongs_to :user
    belongs_to :post

    has_many :comments, foreign_key: 'comment_id'
    belongs_to :comment, foreign_key: 'comment_id'

    has_many :comment_votings
    has_many :voting_users, through: :comment_votings,class_name: 'User', :source => :user

    has_many :comment_votings_pro, -> { joins(:comment_votings).where("#{table_name}.against = ?", false) }, class_name: 'CommentVoting'
    has_many :users_pro, through: :comment_votings_pro, source: :user

    has_many :comment_votings_against, -> { joins(:comment_votings).where("#{table_name}.against = ?", true) }, class_name: 'CommentVoting'
    has_many :users_against, through: :comment_votings_against, source: :user

    scope :by_user, ->(user) { where(user_id: user.id) }
    scope :preview, ->{reorder(created_at: :desc).limit(2)}
    scope :after_last_visit, ->(last_time) { where("#{table_name}.created_at >= ?", last_time) if last_time.present?}
    scope :stage_comments_for, -> (project) { joins(:post).where("#{table_name.gsub('_comments', '_posts')}.project_id = ?", project.id)
                                                  .reorder("#{table_name.gsub('_posts', '_comments')}.created_at DESC")}
    default_scope -> { order 'created_at ASC' }

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

    def add_score
       self.toggle!(:useful)
       if @comment.useful
         self.user.add_score(type: :plus_comment, project: self.post.project, comment: self, path: self.post.class.name.underscore.pluralize)
       else
         self.user.add_score(type: :to_archive_plus_comment, project: self.post.project, comment: self, path: self.post.class.name.underscore.pluralize)
       end
    end

  end
end
