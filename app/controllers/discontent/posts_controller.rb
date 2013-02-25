class Discontent::PostsController < PostsController
  # GET /discontent/posts
  # GET /discontent/posts.json
  def current_model
    Discontent::Post
  end 
  
  def comment_model
    Discontent::Comment
  end
  before_filter :get_post

  def get_post
  	puts '________________________-'
  	puts params
    # @post = Discontent::Post.find(params[:id])
    # // You could also do error checking in before_filters
  end
  

end
