class Plan::PostsController < PostsController
  #autocomplete :concept_post, :resource, :class_name: 'Concept::Post' , :full: true

  def voting_model
    Plan::Post
  end

  def prepare_data
    @aspects = Core::Aspect.where(project_id: @project, status: 0)
    @vote_all = Plan::Voting.where(plan_votings: {plan_post_id: @project.plan_post.pluck(:id)}).uniq_user.count if @project.status == 11
  end

  def index
    @posts = current_model.where(project_id: @project, status: 0).order('created_at DESC').paginate(page: params[:page])
    post = Plan::Post.where(project_id: @project, status: 0).first
    @est_stat = post.estimate_status if post
    @comment = comment_model.new
  end

  def new
    @post = current_model.new
  end

  def edit
    @post = Plan::Post.find(params[:id])
  end

  def create
    @post = @project.plan_post.new plan_post_params
    @post.user = current_user
    if @post.save
      current_user.journals.create!(type_event: 'plan_post_save', body: trim_content(@post.name), first_id: @post.id, project: @project)
    end

    respond_to do |format|
      format.js
    end
  end

  def update
    @plan_post = Plan::Post.find(params[:id])
    @plan_post.update_attributes plan_post_params
    respond_to do |format|
      if @plan_post.save
        current_user.journals.build(type_event: 'plan_post_update', body: trim_content(@plan_post.name), first_id: @plan_post.id, project: @project).save!
        format.html { redirect_to plan_post_path(project: @project, id: @plan_post) }
        format.js
      end
    end
  end

  def render_table
    @post = Plan::Post.find(params[:id])
    @render_type = params[:render_type]
  end

  def render_concept_side
    @post = Plan::Post.find(params[:id])
  end

  def view_concept
    @post = Plan::Post.find(params[:id])
    if params[:new_idea]
      @concept_post = Plan::PostAspect.find(params[:con_id])
    elsif params[:what_view]
      @dispost = Discontent::Post.find(params[:post_id])
      @post_stage = Plan::PostStage.find(params[:stage_id])
    else
      @dispost = Discontent::Post.find(params[:post_id])
      @concept_post = Concept::Post.find(params[:con_id])
    end
  end

  def view_concept_table
    @post = Plan::Post.find(params[:id])
    @concept_post = Plan::PostAspect.find(params[:con_id])
  end

  def change_estimate_status
    @est_stat = params[:est_stat]
    posts = Plan::Post.where(project_id: @project, status: 0)
    if posts.present? and @est_stat.present?
      posts.each do |est|
        est.update_attributes(estimate_status: @est_stat)
      end
    end
  end

  # @todo methods for note
  def new_note
    super()
    @post_aspect_note = Plan::PostAspect.find(params[:con_id])
  end

  def create_note
    @post = current_model.find(params[:id])
    @type = params[:plan_note][:type_field]
    @post_aspect_note = Plan::PostAspect.find(params[:con_id])
    @post_note = @post_aspect_note.plan_notes.build(params[name_of_note_for_param])
    @post_note.user = current_user

    current_user.journals.build(type_event: 'my_plan_note', user_informed: @post.user, project: @project, body: trim_content(@post_note.content), body2: trim_content(@post.name), first_id: @post.id, second_id: @post_aspect_note.id, personal: true, viewed: false).save!

    respond_to do |format|
      if @post_note.save
        format.js
      else
        format.js { render action: "new_note" }
      end
    end
  end

  def destroy_note
    @post_aspect_note = Plan::PostAspect.find(params[:con_id])
    super()
  end

  private
  def plan_post_params
    params.require(:plan_post).permit(:goal, :name, :content)
  end
end
