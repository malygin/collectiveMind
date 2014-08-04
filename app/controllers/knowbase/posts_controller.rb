class Knowbase::PostsController <  PostsController
  layout "application_two_column"
  before_filter :project_by_id

  def current_model
    Knowbase::Post
  end

  def  project_by_id
    unless params[:project].nil?
      @project = Core::Project.find(params[:project])

    end
    add_breadcrumb I18n.t('menu.base_knowledge'), knowbase_posts_path(@project)
  end

  def index
    #redirect_to knowbase_post_path(@project, id:1)

    @stages = current_model.stage_knowbase_order(@project.id)
    @post = current_model.min_stage_knowbase_post(@project.id).first
    #if @post.nil?
      #redirect_to  polymorphic_path(@project.redirect_to_current_stage)
      #redirect_to :back
    #end
    #if @post
    #  add_breadcrumb  @post.title, knowbase_post_path(@project, @post.id)
    #end
    render 'show'
  end

  def new
    @aspects = Discontent::Aspect.where(:project_id => @project)
    @stages = current_model.stage_knowbase_order(@project.id)
    @post = current_model.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @stages = current_model.stage_knowbase_order(@project.id)
    @post = current_model.create(params[:knowbase_post])
    @post.stage = current_model.maximum(:stage) + 1
    @post.project_id = @project.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to  "/project/#{@project.id}/knowbase/posts/#{@post.id}" }
      else
        format.js {render 'new'}
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
    #add_breadcrumb @post.title, knowbase_post_path(@project, @post.id)
  end

  def edit
    @aspects = Discontent::Aspect.where(:project_id => @project)
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
