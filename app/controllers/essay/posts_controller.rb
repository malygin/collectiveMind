# encoding: utf-8
class Essay::PostsController < PostsController


  def current_model
    Essay::Post
  end 
  
  def comment_model
    Essay::Comment
  end



  def index
    @posts = Essay::Post.where(:stage => params[:stage])    
  end

end
