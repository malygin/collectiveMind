class Discontent::PostsController < PostsController
  include Discontent::PostsHelper

  before_action :set_aspects, only: [:index]

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
    if  params[:aspect]
      @posts = Core::Aspect.find(params[:aspect].scan(/\d/).join('')).aspect_posts
    else
      @posts = @project.discontents.by_status_for_discontent(@project)
    end
    respond_to do |format|

      format.html # show.html.erb
      format.json { render json: @posts.map {|item| {id: item.id, content: item.content, whend: item.whend, whered: item.whered,
                                                     user:item.user.to_s, post_date: Russian::strftime(item.created_at,'%d.%m.%Y %k:%M:%S'),
                                                     project_id: item.project_id, sort_date: item.created_at.to_datetime.to_f, sort_rate: (item.users_pro.count + (item.number_views * 0.3)),
                                                     aspect_class: post_aspect_classes(item),
                                                     aspects: item.post_aspects.map {|aspect|{id: aspect.id, color: aspect.color, content: aspect.content} } }  } }

    end

    # @posts = @project.get_united_posts_for_vote(current_user)
    #
    # if params[:asp]
    #   @aspect = Core::Aspect.find(params[:asp])
    # else
    #   @aspect = @project.proc_aspects.order('position DESC').first
    # end
    # @accepted_posts = @project.discontents.by_status([2, 4])
    # @page = params[:page]
    # if params[:not_aspect]
    #   @posts = @project.discontents_without_aspect.by_status_for_discontent(@project).order("discontent_posts.id DESC").filter(filtering_params(params))
    # elsif params[:all_aspects]
    #   @posts = @project.discontents.by_status([0, 1]).order("discontent_posts.id DESC").filter(filtering_params(params))
    # else
    #   @posts = @aspect.aspect_posts.by_status_for_discontent(@project).order("discontent_posts.id DESC").filter(filtering_params(params)) if @aspect
    #   respond_to do |format|
    #     format.html
    #     format.js
    #   end
    # end
  end

  def new
    @asp = params[:asp] ? Core::Aspect.find(params[:asp]) : @project.proc_aspects.order(:id).first
    @post = current_model.new

    if params[:improve_stage]
      @comment = get_comment_for_stage(params[:improve_stage], params[:improve_comment]) unless params[:improve_comment].nil?
    end

    @post.content = @comment.content if @comment
    @aspects = Core::Aspect.where(project_id: @project, status: 0)
    respond_to do |format|
      format.js
    end
  end

  def edit
    @post = current_model.find(params[:id])
    @aspects = Core::Aspect.where(project_id: @project, status: 0)
    @aspects_for_post = @post.post_aspects
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @post = @project.discontents.build(discontent_post_params)
    @post.user = current_user
    @post.improve_comment = params[:improve_comment]
    @post.improve_stage = params[:improve_stage]
    @post.status = 4 if params[:required]
    if params[:discontent_post_aspects]
      @aspect_id = params[:discontent_post_aspects].first
      params[:discontent_post_aspects].each do |asp|
        @post.discontent_post_aspects.build(aspect_id: asp.to_i)
      end
    end
    if @post.save
      current_user.journals.create!(type_event: 'discontent_post_save', anonym: @post.anonym, body: trim_content(@post.content), first_id: @post.id, project: @project)
    end
  end

  def update
    @post = current_model.find(params[:id])
    unless params[:discontent_post_aspects].nil?
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
  # @todo REF remove union methods to concern
  def union_discontent
    @post = Discontent::Post.find(params[:id])
    @new_post = @project.discontent_post.create(status: 2, style: @post.style, content: params[:union_post_descr], whered: @post.whered, whend: @post.whend)
    @new_post.save!
    unless params[:posts].nil?
      params[:posts].each do |p|
        post = Discontent::Post.find(p)
        post.update_attributes(status: 1, discontent_post_id: @new_post.id)
        @new_post.update_union_post_aspects(post.post_aspects)
      end
    end
    @post.update_attributes(status: 1, discontent_post_id: @new_post.id)
    @new_post.update_union_post_aspects(@post.post_aspects)
    redirect_to discontent_post_path(@project, @new_post)
  end

  def unions
    @accepted_posts = @project.discontent_post.by_status([2, 4])
    @posts = current_model.where(project_id: @project).where(status: [2, 4]).created_order
    respond_to do |format|
      format.js
    end
  end

  def remove_union
    @post = Discontent::Post.find(params[:id])
    @union_post = Discontent::Post.find(params[:post_id])
    if @post.one_last_post? and boss?
      @union_post.update_attributes(status: 0, discontent_post_id: nil)
      @post.update_column(:status, 3)
      redirect_to action: 'index'
    else
      @union_post.update_attributes(status: 0, discontent_post_id: nil)
      @post.destroy_ungroup_aspects(@union_post)
      respond_to do |format|
        format.js
      end
    end
  end

  # ------
  # @todo REF remove methods to concern
  def ungroup_union
    @post = Discontent::Post.find(params[:id])
    unless @post.discontent_posts.nil?
      @post.discontent_posts.each do |post|
        post.update_attributes(status: 0, discontent_post_id: nil)
      end
    end
    @post.update_column(:status, 3)
    redirect_to action: 'index'
  end

  def add_union
    @post = Discontent::Post.find(params[:id])
    @union_post = Discontent::Post.find(params[:post_id])
    @union_post.update_attributes(status: 1, discontent_post_id: @post.id)
    @post.update_union_post_aspects(@union_post.post_aspects)
  end

  def next_post_for_vote
    @post_vote = voting_model.find(params[:id])
    @post_vote.final_votings.create(user: current_user, against: params[:against]) unless @post_vote.voted_users.include? current_user
    @votes = current_user.voted_discontent_posts.where(project_id: @project).count
    @post_all = current_model.where(project_id: @project, status: [2, 4]).count
  end

  def set_required
    @post = Discontent::Post.find(params[:id])
    if boss? or role_expert?
      if @post.status == 2
        @post.update_attributes(status: 4)
      elsif @post.status == 4
        @post.update_attributes(status: 2)
      end
    end
  end

  def set_grouped
    @post = Discontent::Post.find(params[:id])
    @new_post = @project.discontent_post.create(status: 2, style: @post.style, content: @post.content, whered: @post.whered, whend: @post.whend)
    @post.update_attributes(status: 1, discontent_post_id: @new_post.id)
    @new_post.update_union_post_aspects(@post.post_aspects)
  end

  def new_group
    @asp = Core::Aspect.find(params[:asp]) unless params[:asp].nil?
    @aspects = Core::Aspect.where(project_id: @project, status: 0)
    @post_group = current_model.new
    respond_to do |format|
      format.js
    end
  end

  def create_group
    @post_group = @project.discontents.create(params[name_of_model_for_param])
    @post_group.status = 2
    @post_group.save
    unless params[:discontent_post_aspects].nil?
      params[:discontent_post_aspects].each do |asp|
        Discontent::PostAspect.create(post_id: @post_group.id, aspect_id: asp.to_i).save!
      end
    end
    @accepted_posts = @project.discontent_post.by_status([2, 4])
    respond_to do |format|
      format.js
    end
  end

  def union_group
    @post = Discontent::Post.find(params[:id])
    @new_post = Discontent::Post.find(params[:group_id])
    if @post and @new_post
      @post.update_attributes(status: 1, discontent_post_id: @new_post.id)
      @new_post.update_union_post_aspects(@post.post_aspects)
    end
    @type_tab = params[:type_tab]
    @parent_post = params[:parent_post_id]
    @accepted_posts = @project.discontent_post.by_status([2, 4])
    respond_to do |format|
      format.js
    end
  end

  def edit_group
    @asp = Core::Aspect.find(params[:asp]) unless params[:asp].nil?
    @aspects = Core::Aspect.where(project_id: @project, status: 0)
    @post_group = current_model.find(params[:id])
    @aspects_for_post = @post_group.post_aspects
    respond_to do |format|
      format.js
    end
  end

  def update_group
    @post_group = current_model.find(params[:id])
    unless params[:discontent_post_aspects].nil?
      @post_group.update_status_fields(params[name_of_model_for_param])
      @post_group.update_attributes(params[name_of_model_for_param])
      @post_group.update_post_aspects(params[:discontent_post_aspects])
    end
    @accepted_posts = Discontent::Post.where(project_id: @project, status: [2, 4])
    respond_to do |format|
      format.js
    end
  end

  def vote_result
    @posts = voting_model.where(project_id: @project, status: [2, 4])
  end

  def sort_content
    @aspect = Core::Aspect.find(params[:asp])
    if params[:sort_default]
      @posts = @aspect.aspect_posts.by_status_for_discontent(@project).order("discontent_posts.id DESC").filter(filtering_params(params))
    else
      @posts = @aspect.aspect_posts.by_status_for_discontent(@project).filter(filtering_params(params)).filter(sorting_params(params))
    end
  end

  def show_comments
    @post = current_model.find(params[:id])
    @comments = @post.main_comments.paginate(page: params[:page] ? params[:page] : last_page, per_page: 10)
    @comment = comment_model.new
    respond_to do |format|
      format.js
    end
  end

  private

  def set_aspects
    # @todo выбираем только аспекты первого уровня (без вложенности) и только основные (прошедшие голосование)
    @aspects = @project.proc_main_aspects
  end

  def discontent_post_params
    params.require(:discontent_post).permit(:content, :whend, :whered, :style)
  end

  def filtering_params(params)
    params.slice(:type_like, :type_note, :type_verify, :type_status)
  end

  def sorting_params(params)
    params.slice(:sort_date, :sort_user, :sort_comment, :sort_view)
  end
end
