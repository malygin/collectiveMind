# encoding: utf-8

class ExpertNews::PostsController  < PostsController


  def current_model
    ExpertNews::Post
  end 
  
  def comment_model
    ExpertNews::Comment
  end

end
