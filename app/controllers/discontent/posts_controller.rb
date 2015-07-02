class Discontent::PostsController < PostsController
  include MarkupHelper
  include CloudinaryHelper

  before_action :set_aspects, only: [:index, :new, :edit]
  before_action :set_discontent_post, only: [:edit, :update, :destroy]

  def voting_model
    Discontent::Post
  end

  # @todo Discontent::PostWhen в ресурсы? или просто искать по ним?
  def autocomplete
    field = params[:field]
    if current_model.column_names.include? field
      render json: current_model.send("autocomplete_#{field}", params[:term]).map { |post| { value: post.send(field) } }
    else
      render json: []
    end
  end

  def index
    @posts = @project.discontents_for_discussion
    @last_time_visit = params[:last_time_visit]
    @user_voter = UserDecorator.new current_user if current_user.can_vote_for(:discontent, @project)
    @project_result = ProjectDecorator.new @project unless @project.stage == '2:0'
    respond_to :html, :json
  end

  def new
    @post = current_model.new
    respond_to do |format|
      format.html
      format.js
    end
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
      current_user.journals.create!(type_event: 'discontent_post_save', anonym: @post.anonym, body: trim_content(@post.content),
                                    first_id: @post.id, project: @project.project)
    end
    respond_to :js
  end

  def update
    if params[:discontent_post_aspects]
      @post.update_attributes(discontent_post_params)
      @post.update_post_aspects(params[:discontent_post_aspects])
      current_user.journals.create!(type_event: "#{name_of_model_for_param}_update", anonym: @post.anonym, project: @project.project,
                                    body: trim_content(@post.content), first_id: @post.id)
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
    @aspects = @project.main_aspects
  end

  def discontent_post_params
    params.require(:discontent_post).permit(:content, :whend, :whered, :style, :what)
  end
end
