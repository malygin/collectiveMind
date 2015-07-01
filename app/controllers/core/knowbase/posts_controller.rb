class Core::Knowbase::PostsController < PostsController
  def index
    @aspects = @project.main_aspects

    # @stages = current_model.stage_knowbase_order(@project.id)
    # @post = current_model.min_stage_knowbase_post(@project.id).first
    # render 'show'
  end

  def new
    @aspects = Aspect::Post.where(project_id: @project)
    @stages = current_model.stage_knowbase_order(@project.id)
    @post = current_model.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @post = @project.knowbase_posts.build(params[:knowbase_post])
    @post.stage = current_model.maximum(:stage).nil? ? 1 : current_model.maximum(:stage) + 1
    respond_to do |format|
      if @post.save
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    @post = current_model.find(params[:id])
    @post.destroy if boss?
    redirect_to knowbase_posts_path(@project)
  end

  def show
    @stages = current_model.stage_knowbase_order(@project.id)
    @post = current_model.stage_knowbase_post(@project.id, params[:id]).first
  end

  def edit
    @aspects = Aspect::Post.where(project_id: @project)
    @post = current_model.find(params[:id])
  end

  def update
    @post = current_model.find(params[:id])
    @post.update_attributes(params[:knowbase_post])
    current_user.journals.build(type_event: 'knowbase_edit',  project: @project,
                                first_id: @post.aspect.id, body: @post.aspect.content,
                                personal: false).save!
    respond_to do |format|
      format.js
    end
  end

  def sortable_save
    current_model.knowbase_posts_sort(params[:sortable])
    respond_to do |format|
      format.js
    end
  end
end
