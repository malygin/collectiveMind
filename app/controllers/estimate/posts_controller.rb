class Estimate::PostsController < PostsController
  def voting_model
    Plan::Post
  end

  def index
    @posts = Plan::Post.where(project_id: @project, status: 1)
  end

  def show
    @post = Plan::Post.find(params[:id])
    @comment = comment_model.new
    @comments = @post.main_comments
    respond_to :html, :js
  end
end
