require 'similar_text'
require 'set'

class Discontent::PostsController < PostsController
  autocomplete :discontent_post, :whend, class_name: 'Discontent::Post', full: true
  autocomplete :discontent_post, :whered, class_name: 'Discontent::Post', full: true

  #@todo объединить autocomplete в один метод
  def autocomplete_discontent_post_whend
    pr=Set.new
    pr.merge(Discontent::PostWhen.where(project_id: params[:project]).map { |d| {value: d.content} })
    if params[:term].length > -1
      pr.merge(Discontent::Post.select('DISTINCT whend as value').where('LOWER(whend) like LOWER(?)', "%#{params[:term]}%")
                   .where(project_id: params[:project]).map { |d| {value: d.value} })
    end
    render json: pr
  end

  def autocomplete_discontent_post_whered
    pr=Set.new
    pr.merge(Discontent::PostWhere.where(project_id: params[:project]).map { |d| {value: d.content} })
    if params[:term].length > -1
      pr.merge(Discontent::Post.select('DISTINCT whered as value').where('LOWER(whered) like LOWER(?)', "%#{params[:term]}%")
                   .where(project_id: params[:project]).map { |d| {value: d.value} })
    end
    render json: pr
  end

  def current_model
    Discontent::Post
  end

  def voting_model
    Discontent::Post
  end

  def note_model
    Discontent::Note
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
    @aspects = Discontent::Aspect.where(project_id: @project, status: 0)
    if @project.status == 6
      @vote_all = Discontent::Voting.by_posts_vote(@project.discontents.by_status([2, 4]).pluck(:id).join(", ")).uniq_user.count
    end
  end

  def index
    return redirect_to action: 'vote_list' if current_user.can_vote_for(:discontent, @project)
    @aspect = params[:asp] ? Discontent::Aspect.find(params[:asp]) : (@project.proc_aspects.first.position.present? ? @project.proc_aspects.order("position DESC").first : @project.proc_aspects.order(:id).first)
    @accepted_posts = Discontent::Post.where(project_id: @project, status: 2)
    @comments_all = @project.problems_comments_for_improve
    @page = params[:page]
    @posts = @aspect.aspect_posts.by_status_for_discontent(@project).order("discontent_posts.id DESC").filter(filtering_params(params))
  end

  def new
    @asp = params[:asp] ? Discontent::Aspect.find(params[:asp]) : @project.proc_aspects.order(:id).first
    @post = current_model.new

    if params[:improve_stage]
      @comment = get_comment_for_stage(params[:improve_stage], params[:improve_comment]) unless params[:improve_comment].nil?
    end
    @post.content = @comment.content if @comment
  end

  def edit
    @post = current_model.find(params[:id])
    @aspects_for_post = @post.post_aspects
    respond_to do |format|
      format.html
      format.js
    end
  end


  def vote_list
    @posts = @project.get_united_posts_for_vote(current_user)
    return redirect_to action: 'index' if @posts.empty?
    @post_all = current_model.where(project_id: @project, status: 2).count
    @votes = current_user.voted_discontent_posts.where(project_id: @project).count
    @status = 2
  end

  def create
    @project = Core::Project.find(params[:project])
    #@aspects = Discontent::Aspect.where(project_id: @project, status: 0)
    @post = @project.discontents.build(params[name_of_model_for_param])
    @post.user = current_user
    @post.improve_comment = params[:improve_comment] if params[:improve_comment]
    @post.improve_stage = params[:improve_stage] if params[:improve_stage]
    @post.status = 4 if params[:required]
    if params[:discontent_post_aspects]
      @aspect_id = params[:discontent_post_aspects].first
      params[:discontent_post_aspects].each do |asp|
        @post.discontent_post_aspects.build(aspect_id: asp.to_i)
      end
    end
    respond_to do |format|
      if @post.save
        current_user.journals.build(type_event: 'discontent_post_save', anonym: @post.anonym, body: trim_content(@post.content), first_id: @post.id, project: @project).save!
        # current_user.add_score(type: :add_discontent_post)
        format.js
      else
        format.js
      end
    end
  end

  def update
    @post = current_model.find(params[:id])
    @project = Core::Project.find(params[:project])
    unless params[:discontent_post_aspects].nil?
      @post.update_status_fields(params[name_of_model_for_param])
      @post.update_attributes(params[name_of_model_for_param])
      @post.update_post_aspects(params[:discontent_post_aspects])
      @aspect_id = params[:discontent_post_aspects].first
      current_user.journals.build(type_event: name_of_model_for_param+'_update', anonym: @post.anonym , project: @project, body: trim_content(@post.content), first_id: @post.id).save!
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def union_discontent
    @project = Core::Project.find(params[:project])
    @post = Discontent::Post.find(params[:id])
    @new_post =Discontent::Post.create(status: 2, style: @post.style, project: @project, content: params[:union_post_descr], whered: @post.whered, whend: @post.whend)
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
    @project = Core::Project.find(params[:project])
    @accepted_posts = Discontent::Post.where(project_id: @project, status: 2)
    @posts = current_model.where(project_id: @project).where(status: 2).order_by_param(@order).paginate(page: params[:page], per_page: 40)
    @list_type = params[:list_type]
    respond_to do |format|
      format.js
    end
  end

  def remove_union
    @project = Core::Project.find(params[:project])
    @post = Discontent::Post.find(params[:id])
    @union_post = Discontent::Post.find(params[:post_id])
    if @post.one_last_post? and boss?
      @union_post.update_attributes(status: 0, discontent_post_id: nil)
      @post.update_column(:status, 3)
      return redirect_to action: "index"
    else
      @union_post.update_attributes(status: 0, discontent_post_id: nil)
      @post.destroy_ungroup_aspects(@union_post)
      respond_to do |format|
        format.js
      end
    end
  end

   def ungroup_union
     @project = Core::Project.find(params[:project])
     @post = Discontent::Post.find(params[:id])
     unless @post.discontent_posts.nil?
       @post.discontent_posts.each do |post|
         post.update_attributes(status: 0, discontent_post_id: nil)
       end
     end
     @post.update_column(:status, 3)
     redirect_to action: "index"
   end

  def add_union
    @project = Core::Project.find(params[:project])
    @post = Discontent::Post.find(params[:id])
    @union_post = Discontent::Post.find(params[:post_id])
    @union_post.update_attributes(status: 1, discontent_post_id: @post.id)
    @post.update_union_post_aspects(@union_post.post_aspects)
  end

  def next_post_for_vote
    @project = Core::Project.find(params[:project])
    @post_vote = voting_model.find(params[:id])
    @post_vote.final_votings.create(user: current_user, against: params[:against]) unless @post_vote.voted_users.include? current_user
    @votes = current_user.voted_discontent_posts.where(project_id: @project).count
    @post_all = current_model.where(project_id: @project, status: 2).count
  end

  def set_required
    @post = Discontent::Post.find(params[:id])
    if boss? and @post.status == 2
      @post.update_attributes(status: 4)
    end
  end

  def set_grouped
    @project = Core::Project.find(params[:project])
    @post = Discontent::Post.find(params[:id])
    @new_post = Discontent::Post.create(status: 2, style: @post.style, project: @project, content: @post.content, whered: @post.whered, whend: @post.whend)
    @post.update_attributes(status: 1, discontent_post_id: @new_post.id)
    @new_post.update_union_post_aspects(@post.post_aspects)
  end

  def new_group
    @project = Core::Project.find(params[:project])
    @asp = Discontent::Aspect.find(params[:asp]) unless params[:asp].nil?
    @aspects = Discontent::Aspect.where(project_id: @project, status: 0)
    @post_group = current_model.new
    respond_to do |format|
      format.js
    end
  end

  def create_group
    @project = Core::Project.find(params[:project])
    @post_group = @project.discontents.create(params[name_of_model_for_param])
    @post_group.status = 2
    @post_group.save
    unless params[:discontent_post_aspects].nil?
      params[:discontent_post_aspects].each do |asp|
        Discontent::PostAspect.create(post_id: @post_group.id, aspect_id: asp.to_i).save!
      end
    end
    @accepted_posts = Discontent::Post.where(project_id: @project, status: 2)
    respond_to do |format|
      format.js
    end
  end

  def union_group
    @project = Core::Project.find(params[:project])
    @post = Discontent::Post.find(params[:id])
    @new_post = Discontent::Post.find(params[:group_id])
    if @post and @new_post
      @post.update_attributes(status: 1, discontent_post_id: @new_post.id)
      @new_post.update_union_post_aspects(@post.post_aspects)
    end
    @type_list = params[:type_list]
    @parent_post = params[:parent_post]
    @accepted_posts = Discontent::Post.where(project_id: @project, status: 2)
    respond_to do |format|
      format.js
    end
  end

  def edit_group
    @project = Core::Project.find(params[:project])
    @asp = Discontent::Aspect.find(params[:asp]) unless params[:asp].nil?
    @aspects = Discontent::Aspect.where(project_id: @project, status: 0)
    @post_group = current_model.find(params[:id])
    @aspects_for_post = @post_group.post_aspects
    respond_to do |format|
      format.js
    end
  end

  def update_group
    @project = Core::Project.find(params[:project])
    @post_group = current_model.find(params[:id])
    unless params[:discontent_post_aspects].nil?
      @post_group.update_status_fields(params[name_of_model_for_param])
      @post_group.update_attributes(params[name_of_model_for_param])
      @post_group.update_post_aspects(params[:discontent_post_aspects])
    end
    @accepted_posts = Discontent::Post.where(project_id: @project, status: 2)
    respond_to do |format|
      format.js
    end
  end

  def vote_result
    @project = Core::Project.find(params[:project])
    @posts = voting_model.where(project_id: @project, status: [2,4])
  end

  def sort_content
    @project = Core::Project.find(params[:project])
    @aspect = Discontent::Aspect.find(params[:asp])
    if params[:sort_default]
      @posts = @aspect.aspect_posts.by_status_for_discontent(@project).order("discontent_posts.id DESC").filter(filtering_params(params))
    else
      @posts = @aspect.aspect_posts.by_status_for_discontent(@project).filter(filtering_params(params)).filter(sorting_params(params))
    end
  end

  private
  def filtering_params(params)
    params.slice(:type_like, :type_note, :type_verify, :type_status)
  end
  def sorting_params(params)
    params.slice(:sort_date, :sort_user, :sort_comment, :sort_view)
  end

end
