class CompletionProc::PostsController < PostsController

  def voting_model
    Plan::Post
  end

  def current_model
    Plan::Post
  end

  def index

  end

end
