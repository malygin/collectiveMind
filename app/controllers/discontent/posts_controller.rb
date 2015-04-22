class Discontent::PostsController < PostsController
  include Discontent::PostsHelper
  include DiscontentGroup

  before_action :set_aspects, only: [:index, :new]

  def voting_model
    Discontent::Post
  end

  #@todo Discontent::PostWhen в ресурсы? или просто искать по ним?
  def autocomplete
    field = params[:field]
    if current_model.column_names.include? field
      render json: current_model.send("autocomplete_#{field}", params[:term]).map { |post| {value: post.send(field)} }
    else
      render json: []
    end
  end

  def index
    @posts= nil
    if params[:aspect] and params[:aspect] != '*'
      @posts = Core::Aspect::Post.find(params[:aspect].scan(/\d/).join('')).aspect_posts
    else
      @posts = @project.discontents.by_status_for_discontent(@project)
    end
    respond_to do |format|

      format.html # show.html.erb
      format.json { render json: @posts.each_with_index.map { |item, index| {id: item.id, index: index+1, content: trim_post_content(item.content, 50), what: trim_post_content(item.what, 100), whend: item.whend, whered: item.whered,
                                                                             user: item.user.to_s, user_avatar: ActionController::Base.helpers.asset_path('no-ava.png'), post_date: Russian::strftime(item.created_at, '%d.%m.%Y'),
                                                                             project_id: item.project_id, sort_date: item.created_at.to_datetime.to_f, sort_comment: item.last_comment.present? ? item.last_comment.created_at.to_datetime.to_f : 0,
                                                                             aspect_class: post_aspect_classes(item),
                                                                             count_comments: item.comments.count,
                                                                             count_likes: item.users_pro.count,
                                                                             count_dislikes: item.users_against.count,
                                                                             aspects: item.aspect ? [{id: item.aspect.id, color: item.aspect.color, content: item.aspect.content}] : [],
                                                                             comments: item.comments.preview.map { |comment| {id: comment.id, date: Russian::strftime(comment.created_at, '%d.%m.%Y'), user: comment.user.to_s, content: comment.content} }} } }

    end
  end

  def new
    @asp = params[:asp] ? Core::Aspect::Post.find(params[:asp]) : @aspects.first
    @post = current_model.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @post = current_model.find(params[:id])
    @aspects_for_post = @post.post_aspects
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @post = @project.discontents.build(discontent_post_params)
    @post.user = current_user
    # if params[:discontent_post_aspects]
    #   @aspect_id = params[:discontent_post_aspects].first
    #   params[:discontent_post_aspects].each do |asp|
    #     @post.discontent_post_aspects.build(aspect_id: asp.to_i)
    #   end
    # end
    if @post.save
      current_user.journals.create!(type_event: 'discontent_post_save', anonym: @post.anonym, body: trim_content(@post.content), first_id: @post.id, project: @project)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @post = current_model.find(params[:id])
    if params[:discontent_post_aspects]
      @post.update_status_fields(params[name_of_model_for_param])
      @post.update_attributes(params[name_of_model_for_param])
      @post.update_post_aspects(params[:discontent_post_aspects])
      @aspect_id = params[:discontent_post_aspects].first
      current_user.journals.create!(type_event: "#{name_of_model_for_param}_update", anonym: @post.anonym, project: @project, body: trim_content(@post.content), first_id: @post.id)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_aspects
    # @todo выбираем только аспекты первого уровня (без вложенности) и только основные (прошедшие голосование)
    @aspects = @project.proc_main_aspects
  end

  def discontent_post_params
    params.require(:discontent_post).permit(:content, :whend, :whered, :style, :what)
  end
end
