class CompletionProc::PostsController < PostsController
  def voting_model
    Plan::Post
  end

  def current_model
    Plan::Post
  end

  def index
    @posts = @project.plans_approved
  end

  def show
    @post = Plan::Post.find(params[:id])
    respond_to :html, :js
  end
end
