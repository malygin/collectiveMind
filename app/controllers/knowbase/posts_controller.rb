class Knowbase::PostsController <  PostsController
  before_filter :prepare_data
  before_filter :journal_data

  def current_model
    Knowbase::Post
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
  end

  def index
    @stages = current_model.stage_knowbase_order(@project.id)
    @post = current_model.min_stage_knowbase_post(@project.id).first
    render 'show'
  end

  def new
    @aspects = Discontent::Aspect.where(project_id: @project)
    @stages = current_model.stage_knowbase_order(@project.id)
    @post = current_model.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @stages = current_model.stage_knowbase_order(@project.id)
    @flash = view_context.validate_knowbase(params[:knowbase_post])
    unless @flash.present?
      @post = current_model.create(params[:knowbase_post])
      @post.stage = current_model.maximum(:stage) + 1
      @post.project_id = @project.id
      respond_to do |format|
        if @post.save
          format.html { redirect_to  "/project/#{@project.id}/knowbase/posts/#{@post.id}" }
        else
          format.html {render 'new'}
        end
      end
    else
      @aspects = Discontent::Aspect.where(project_id: @project)
      @stages = current_model.stage_knowbase_order(@project.id)
      @post = current_model.new
      respond_to do |format|
        format.html {render action: 'new'}
      end
    end
  end

  def destroy
    @post = current_model.find(params[:id])
    @post.destroy if current_user.boss?
    redirect_to knowbase_posts_path(@project)
  end

  def show
    @stages = current_model.stage_knowbase_order(@project.id)
    @post = current_model.stage_knowbase_post(@project.id, params[:id]).first
  end

  def edit
    @aspects = Discontent::Aspect.where(project_id: @project)
    @post = current_model.find(params[:id])
  end

  def update
    @post = current_model.find(params[:id])
    @post.update_attributes(params[:knowbase_post])
    respond_to do |format|
      format.js
    end
  end

  def sortable_save
    current_model.set_knowbase_posts_sort(params[:sortable])
    respond_to do |format|
      format.js
    end
  end
end
