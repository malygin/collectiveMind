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

    def vote(user, status)
      saved_vote = self.final_votings.where(user_id: user)
      if saved_vote.present?
        vote = saved_vote.first
        if vote.status != status.to_i
          saved_vote.destroy_all
          self.final_votings.create(user: user, status: status).save!
        elsif vote.status == status.to_i
          saved_vote.destroy_all
        end
      else
        self.final_votings.create(user: user, status: status).save!
      end
    end

    def change_status_by(user, params)
      if params[:discuss_status]
        self.toggle!(:discuss_status)
        if self.discuss_status
          type = 'discuss_status'
        end
      elsif params[:approve_status]
        self.toggle!(:approve_status)
        if self.approve_status
          type = 'approve_status'
        end
      end
      if type

        if self.user!=user
          self.user.journals.build(type_event: 'my_'+self.class.table_name.singularize+'_'+type, user_informed: self.user, project: self.project,
                                      body: "#{trim_content(field_for_journal(self))}", first_id: self.id, personal: true, viewed: false).save!
        end
        # if @project.closed?
        #   Resque.enqueue(PostNotification, self.to_s, @project.id, self.user.id, name_of_model_for_param, type, self.id)
        # end
      end
    end

    def add_comment(params, user, comment_parent, comment_answer, name_of_comment_for_journal)
      content = params[:content]
      unless content==''
        if params[:image]
          img, isFile = Util::ImageLoader.load(params)
        end
        comment = self.comments.create(content: content, image: img ? img['public_id'] : nil, isFile: img ? isFile : nil,
                                        user: user, comment_id: comment_parent ? comment_parent.id : nil)
        Journal.comment_event(user, self.project, name_of_comment_for_journal, self, comment, comment_answer)
        return comment
      end
    end

    def add_score
      self.toggle!(:useful)
      if self.useful
        self.user.add_score(type: :plus_post, project: self.project, post: self,
                            type_score: "#{self.class.table_name == 'core_aspect_posts' ? 'collect_info_posts' : self.class.table_name}_score",
                            score: self.class::SCORE, model_score: self.class.table_name.singularize)
      else
        self.user.add_score(type: :to_archive_plus_post, project: self.project, post: self,
                            type_score: "#{self.class.table_name == 'core_aspect_posts' ? 'collect_info_posts' : self.class.table_name}_score",
                            score: self.class::SCORE, model_score: self.class.table_name.singularize)
      end
    end

    def self.prepare_to_show(id, project, viewed)
      post = self.where(id: id, project_id: project).first
      if viewed
        Journal.events_for_content(project, current_user, post.id).update_all("viewed = 'true'")
      end
      if self.column_names.include? 'number_views'
        post.update_column(:number_views, post.number_views.nil? ? 1 : post.number_views+1)
      end
      return post
    end

    def self.create_post(params, project, user)
      post = self.new(params[self.table_name.singularize])
      post.project = project
      post.user = user

      post.stage = params[:stage] unless params[:stage].nil?
      post.core_aspects << Core::Aspect::Post.find(params[:aspect_id]) unless params[:aspect_id].nil?
      post.style = params[:style] unless params[:style].nil?
      post.status = 0 if self.column_names.include? 'status'
      post.save!
      user.journals.build(type_event: name_of_model_for_param+"_save", project: project, body: post.content == '' ? t('link.more') : trim_content(post.content), first_id: post.id).save!
      return post
    end

    # generic method for statuses, for example publish?
    STATUSES.keys.each do |method_name|
      define_method :"#{method_name}?" do
        status == STATUSES[method_name]
      end
    end
  end
end



