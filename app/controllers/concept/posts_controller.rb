class Concept::PostsController < PostsController
  include MarkupHelper
  include CloudinaryHelper
  before_action :set_concept_post, only: [:edit, :update, :destroy]
  before_action :set_discontent_posts, only: [:new, :edit]

  def voting_model
    Concept::Post
  end

  def autocomplete
    # @todo для универсализации автокомплита, нужно объединить все ресурсные модели
    field = params[:field]
    answer = Set.new
    answer.merge(Concept::Resource.where(project_id: params[:project]).map { |d| { value: d.name } })
    answer.merge(Concept::PostResource.autocomplete(params[:term]).where(project_id: params[:project], style: (field == 'resor_means_name' ? 1 : 0)).map { |d| { value: d.name } })

    render json: answer.sort_by { |ha| ha[:value].downcase }
  end

  def index
    @posts = nil
    if params[:discontent] && params[:discontent] != '*'
      # @posts = Discontent::Post.find(params[:discontent].scan(/\d/).join('')).dispost_concepts.created_order
      # @posts = @project.concept_ongoing_post.joins(:concept_post_discontents).for_discontents(params[:discontent]).created_order
      if params[:discontent].include?('#')
        params[:discontent].delete('#')
        params[:discontent] += [nil]
      end
      @posts = @project.concept_for_vote.includes(:concept_post_discontents).where(concept_post_discontents: { discontent_post_id: params[:discontent] }).created_order
    else
      @posts = @project.concept_for_vote.created_order
    end
    @user_voter = UserDecorator.new current_user if current_user.can_vote_for(:concept, @project)

    respond_to :html, :json
  end

  def new
    # нововведение без аспекта?
    @asp = Core::Aspect::Post.find(params[:asp]) unless params[:asp].nil?
    @concept_post = current_model.new
    # @resources = Concept::Resource.where(project_id: @project.id)
    # if params[:improve_comment] and params[:improve_stage]
    #   @comment = get_comment_for_stage(params[:improve_stage], params[:improve_comment])
    #   @concept_post.name = @comment.content if @comment
    # end
    # @remove_able = true
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @concept_post = current_model.new concept_post_params.merge(user_id: current_user.id, project_id: @project.id)
    unless params[:concept_post_discontents].nil?
      params[:concept_post_discontents].each do |id, _|
        @concept_post.concept_post_discontents.build(discontent_post_id: id, status: 0)
      end
    end

    # выбор отдельных несовершенств
    # unless params[:check_discontent].nil?
    #   params[:check_discontent].each do |com|
    #     @concept_post.concept_post_discontent_checks.build(discontent_post_id: com[0], status: 1)
    #   end
    # end
    # @concept_post.improve_comment = params[:improve_comment] if params[:improve_comment]
    # @concept_post.improve_stage = params[:improve_stage] if params[:improve_stage]
    # create_concept_resources_on_type(@project, @concept_post)

    respond_to do |format|
      if @concept_post.save
        current_user.journals.build(type_event: 'concept_post_save', body: trim_content(@concept_post.title), first_id: @concept_post.id, project: @project).save!
        format.js
      else
        format.js
      end
    end
  end

  def edit
    @discontent_posts -= @concept_post.concept_disposts
    render action: :new
  end

  def update
    @concept_post.update_attributes(concept_post_params)
    if @concept_post.valid? && params[:concept_post_discontents].present?
      @concept_post.concept_post_discontents.destroy_all
      params[:concept_post_discontents].each do |cd|
        @concept_post.concept_post_discontents.build(discontent_post_id: cd[0])
      end
    end
    # unless params[:check_discontent].nil?
    #   @concept_post.concept_post_discontent_checks.destroy_all if @concept_post.valid?
    #   params[:check_discontent].each do |com|
    #     @concept_post.concept_post_discontent_checks.build(discontent_post_id: com[0], status: 1)
    #   end
    # end
    # create_concept_resources_on_type(@project, @concept_post)

    respond_to do |format|
      if @concept_post.save
        current_user.journals.build(type_event: 'concept_post_update', body: trim_content(@concept_post.title), first_id: @concept_post.id, project: @project).save!
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    @concept_post.destroy if current_user?(@concept_post.user)
    redirect_back_or user_content_concept_posts_path(@project)
  end

  def add_dispost
    @dispost = Discontent::Post.find(params[:dispost_id])
    @remove_able = true
  end

  private

  def set_discontent_posts
    @discontent_posts = Discontent::Post.by_project(@project)
  end

  def set_concept_post
    @concept_post = Concept::Post.find(params[:id])
  end

  def prepare_data
    @aspects = Core::Aspect::Post.where(project_id: @project, status: 0)
    @disposts = Discontent::Post.where(project_id: @project, status: 4).order(:id)
    # if @project.status == 8
    #   @vote_all = Concept::Voting.by_posts_vote(@project.discontents.by_status(4).pluck(:id).join(", ")).uniq_user.count
    # end
  end

  def concept_post_params
    params.require(:concept_post).permit(:goal, :user_id, :number_views, :status, :content, :censored, :discuss_status,
                                         :useful, :approve_status, :title, :actors, :impact_env)
  end
end
