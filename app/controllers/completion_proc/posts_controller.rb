class CompletionProc::PostsController < PostsController
  def voting_model
    Plan::Post
  end

  def current_model
    Plan::Post
  end

  def index
    @posts = @project.completion_plan_posts
  end

  def show
    @post = Plan::Post.find(params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end
end
