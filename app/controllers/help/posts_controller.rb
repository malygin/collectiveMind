class Help::PostsController < PostsController
  def index
    redirect_to help_post_path(@project, id: 1)
  end

  def about
    redirect_to help_post_path(@project, id: 8)
  end

  def show
    @stages = Core::Project::LIST_STAGES
    @posts = {}
    Help::Post.where(stage: params[:id].to_i, mini: false).each { |f| @posts[f.style] = f }
  end

  def edit
    @post = current_model.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @post = current_model.find(params[:id])
    @post.update_attributes(params[:help_post])
    respond_to do |format|
      format.js
    end
  end
end
