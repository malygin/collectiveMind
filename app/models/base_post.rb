module BasePost
  extend ActiveSupport::Concern
  include Util::Filterable
  include ApplicationHelper
  include MarkupHelper

  # Statuses of post
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

    scope :by_project, ->(p) { where(project_id: p) }
    scope :by_user, ->(user) { where(user_id: user.id) }
    scope :by_status, ->(status) { where(status: status) }

    scope :for_expert, -> { where(status: 1) }
    scope :accepted, -> { where(status: 2) }
    scope :archive, -> { where(status: 3) }

    scope :with_votes, -> { includes(:post_votings).where('"discontent_post_votings"."id" > 0') }
    scope :with_concept_votes, -> { includes(:post_votings).where('"concept_post_votings"."id" > 0') }

    scope :created_order, -> { reorder("#{table_name}.created_at DESC") }
    scope :updated_order, -> { reorder("#{table_name}.updated_at DESC") }
    scope :popular_posts, -> { order('number_views DESC') }

    scope :published, -> { where status: STATUSES[:published] }

    # for user's posts which was add from last visit
    scope :after_last_visit_posts, ->(last_time) { where("#{table_name}.created_at >= ?", last_time) if last_time.present? }
    scope :after_last_visit_comments, lambda { |last_time|
      joins(:comments)
        .where("#{table_name.gsub('_posts', '_comments')}.created_at >= ?", last_time) if last_time.present?
    }

    validates :user_id, :project_id, presence: true
    validates :status, inclusion: { in: STATUSES.values }

    # вывод постов по дате последних комментов
    def self.sort_comments
      select("#{table_name}.*, max(#{table_name.gsub('_posts', '_comments')}.created_at) as last_date")
        .joins("LEFT OUTER JOIN #{table_name.gsub('_posts', '_comments')} ON #{table_name.gsub('_posts', '_comments')}.post_id = #{table_name}.id")
        .group("#{table_name}.id")
        .reorder("max(#{table_name.gsub('_posts', '_comments')}.created_at) DESC NULLS LAST")
    end

    def last_comment
      comments.reorder(created_at: :desc).first
    end

    def show_content
      content
    end

    def self.order_by_param(order)
      if order == 'popular'
        popular_posts
      else
        created_order
      end
    end

    def main_comments
      comments.where(comment_id: nil)
    end

    def class_name
      self.class.table_name.singularize
    end

    def class_name_for_url
      self.class.name.underscore.pluralize
    end

    def stage_name
      self.class.name.deconstantize.underscore
    end

    def vote(user, status)
      saved_vote = final_votings.where(user_id: user)
      if saved_vote.present?
        vote_status = saved_vote.first.status
        saved_vote.destroy_all
        return if  vote_status == status.to_i
      end
      final_votings.create(user: user, status: status).save!
    end

    def change_status_by(user, params)
      self.toggle!(params[:status])
      return unless self[params[:status].to_sym] && self.user != user
      self.user.journals.build(type_event: 'my_' + class_name + '_' + params[:status], user_informed: self.user, project: project,
                               body: field_for_journal, first_id: id, personal: true, viewed: false).save!
      # if @project.closed?
      #   # Resque.enqueue(PostNotification, self.to_s, @project.id, self.user.id, name_of_model_for_param, type, self.id)
      # end
    end

    def add_comment(params, user, comment_parent, comment_answer)
      content = params[:content]
      return false if content == ''
      img, is_file = Util::ImageLoader.load(params)  if params[:image]
      comment = comments.create(content: content, image: img ? img['public_id'] : nil, isFile: img ? is_file : nil,
                                user: user, comment_id: comment_parent ? comment_parent.id : nil)
      JournalEventSaver.comment_event(user: user, project: project, post: self, comment: comment, answer: comment_answer)
      comment
    end

    def add_score
      self.toggle!(:useful)
      if useful
        user.add_score_by_type(type: :plus_post, project: project, post: self,
                               type_score: "#{self.class.table_name}_score",
                               score: self.class::SCORE, model_score: self.class.table_name.singularize)
      else
        user.add_score_by_type(type: :to_archive_plus_post, project: project, post: self,
                               type_score: "#{self.class.table_name}_score",
                               score: -self.class::SCORE, model_score: self.class.table_name.singularize)
      end
    end

    def self.prepare_to_show(id, project, viewed)
      post = where(id: id, project_id: project).first
      if viewed
        Journal.events_for_content(project, current_user, post.id).update_all("viewed = 'true'")
      end
      if column_names.include? 'number_views'
        post.update_column(:number_views, post.number_views.nil? ? 1 : post.number_views + 1)
      end
      post
    end

    def self.create_post(params, project, user)
      post = new(params[table_name.singularize])
      post.project = project
      post.user = user

      post.stage = params[:stage] unless params[:stage].nil?
      post.aspects << Aspect::Post.find(params[:aspect_id]) unless params[:aspect_id].nil?
      post.style = params[:style] unless params[:style].nil?
      post.status = 0 if column_names.include? 'status'
      post.save!
      user.journals.build(type_event: name_of_model_for_param + '_save', project: project,
                          body: post.content == '' ? t('link.more') : trim_content(post.content), first_id: post.id).save!
      post
    end

    def field_for_journal
      if self.instance_of?(Concept::Post) || self.instance_of?(Novation::Post)
        title
      elsif self.instance_of? Plan::Post
        name
      else
        content
      end
    end

    # generic method for statuses, for example publish?
    STATUSES.keys.each do |method_name|
      define_method :"#{method_name}?" do
        status == STATUSES[method_name]
      end
    end
  end
end
