class Discontent::PostsController < PostsController
  # GET /discontent/posts
  # GET /discontent/posts.json
  def current_model
    Discontent::Post
  end 
  
  def comment_model
    Discontent::Comment
  end
  

end
