class Core::Knowbase::PostsController < PostsController
  def index
    @aspects = @project.aspects_for_discussion
  end

  # :nocov:
  def new
    @aspects = Aspect::Post.where(project_id: @project)
    @stages = current_model.stage_knowbase_order(@project.id)
    @post = current_model.new
    respond_to :html, :js
  end

  def create
    @post = @project.knowbase_posts.build(params[:knowbase_post])
    @post.stage = current_model.maximum(:stage).nil? ? 1 : current_model.maximum(:stage) + 1
    @post.save
    respond_to :js
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
    current_user.journals.build(type_event: 'knowbase_edit', project: @project,
                                first_id: @post.aspect.id, body: @post.aspect.content,
                                personal: false).save!
    respond_to :js
  end
  # :nocov:
end
