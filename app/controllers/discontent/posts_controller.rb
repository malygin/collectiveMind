class Discontent::PostsController < PostsController
  before_action :set_aspects, only: [:index, :new, :edit]
  before_action :set_discontent_post, only: [:edit, :update, :destroy]
  before_action :user_vote, only: [:index]

  # :nocov:
  # @todo Discontent::PostWhen в ресурсы? или просто искать по ним?
  def autocomplete
    field = params[:field]
    if current_model.column_names.include? field
      render json: current_model.send("autocomplete_#{field}", params[:term]).map { |post| { value: post.send(field) } }
    else
      render json: []
    end
  end
  # :nocov:

  def index
    @posts = @project.discontents_for_discussion
    @last_visit_presenter = LastVisitPresenter.new(project: @project, controller: params[:controller], user: current_user)
    @project_result = ProjectResulter.new @project unless @project.can_add?(name_controller)
    respond_to :html, :json
  end

  def new
    @post = current_model.new
    respond_to :html, :js
  end

  def edit
    render action: :new
  end

  def create
    @post = @project.discontents.build(discontent_post_params)
    @post.user = current_user
    if params[:discontent_post_aspects]
      params[:discontent_post_aspects].each { |asp|  @post.discontent_post_aspects.build(aspect_id: asp.to_i) }
    end
    if @post.save
      JournalEventSaver.post_save_event(user: current_user, project: @project.project, post: @post)
    end
    respond_to :js
  end

  def update
    if params[:discontent_post_aspects]
      @post.update_attributes(discontent_post_params)
      @post.update_post_aspects(params[:discontent_post_aspects])
      JournalEventSaver.post_save_event(user: current_user, project: @project.project, post: @post)
    end
    respond_to :js
  end

  def destroy
    @post.destroy if current_user?(@post.user)
    redirect_back_or user_content_discontent_posts_path(@project)
  end

  private

  def set_discontent_post
    @post = current_model.find(params[:id])
  end

  def set_aspects
    # @todo выбираем только аспекты первого уровня (без вложенности) и только основные (прошедшие голосование)
    @aspects = @project.aspects_for_discussion
  end

  def discontent_post_params
    params.require(:discontent_post).permit(:content, :whend, :whered, :style, :what)
  end
end
