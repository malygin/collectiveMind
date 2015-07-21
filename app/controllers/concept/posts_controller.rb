class Concept::PostsController < PostsController
  before_action :set_concept_post, only: [:edit, :update, :destroy]
  before_action :set_discontent_posts, only: [:new, :edit]
  before_action :set_aspect_posts, only: [:new, :edit]
  before_action :user_vote, only: [:index]

  # :nocov:
  def autocomplete
    # @todo для универсализации автокомплита, нужно объединить все ресурсные модели
    field = params[:field]
    answer = Set.new
    answer.merge(Concept::Resource.where(project_id: params[:project]).map { |d| { value: d.name } })
    answer.merge(Concept::PostResource.autocomplete(params[:term]).where(project_id: params[:project],
                                                                         style: (field == 'resor_means_name' ? 1 : 0)).map { |d| { value: d.name } })
    render json: answer.sort_by { |ha| ha[:value].downcase }
  end
  # :nocov:

  def index
    if params[:discontent] && params[:discontent] != '*'
      @posts = @project.concept_posts_for_vote.includes(:concept_post_discontents)
               .where(concept_post_discontents: { discontent_post_id: params[:discontent] }).created_order
    else
      @posts = @project.concept_posts_for_vote.created_order
    end
    @last_time_visit = params[:last_time_visit]
    @presenter = LastVisitPresenter.new(project: @project, controller: params[:controller], user: current_user)
    @project_result = ProjectResulter.new @project unless @project.can_add?(name_controller)
    respond_to :html, :json
  end

  def new
    # нововведение без аспекта?
    @asp = Aspect::Post.find(params[:asp]) unless params[:asp].nil?
    @concept_post = current_model.new
    respond_to :html, :js
  end

  def create
    @concept_post = current_model.new concept_post_params.merge(user_id: current_user.id, project_id: @project.id)
    unless params[:concept_post_discontents].nil?
      params[:concept_post_discontents].each do |id, _|
        @concept_post.concept_post_discontents.build(discontent_post_id: id, status: 0)
      end
    end
    @concept_post.save
    JournalEventSaver.post_save_event(user: current_user, project: @project.project, post: @concept_post)
    respond_to :js
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
    @concept_post.save
    JournalEventSaver.post_update_event(user: current_user, project: @project.project, post: @concept_post)
    respond_to :js
  end

  def destroy
    @concept_post.destroy if current_user?(@concept_post.user)
    redirect_back_or user_content_concept_posts_path(@project)
  end

  def show_discontents
    return @disposts = current_user.discontent_posts.by_project(@project) if params[:aspect] == '*'
    aspect = Aspect::Post.find(params[:aspect])
    subaspects = aspect.aspects.map { |asp, _| asp.id }
    @disposts = @project.discontents.joins(:discontent_post_aspects).where(discontent_post_aspects: { aspect_id: [aspect.id] + subaspects })
  end

  def search_discontent
    @disposts = @project.discontents.search_discontent params[:search_text]
  end

  private

  def set_discontent_posts
    @discontent_posts = Discontent::Post.by_project(@project)
  end

  def set_aspect_posts
    @aspects = @project.aspects_for_discussion
  end

  def set_concept_post
    @concept_post = Concept::Post.find(params[:id])
  end

  def concept_post_params
    params.require(:concept_post).permit(:goal, :user_id, :number_views, :status, :content, :censored, :discuss_status,
                                         :useful, :approve_status, :title, :actors, :impact_env)
  end
end
