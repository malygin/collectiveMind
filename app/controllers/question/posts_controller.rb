# encoding: utf-8
class Question::PostsController < PostsController

  def current_model
    Question::Post
  end 
  
  def comment_model
    Question::Comment
  end

end