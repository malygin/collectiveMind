# encoding: utf-8
class Essay::PostsController < PostsController
layout "life_tape/posts"

  def current_model
    Essay::Post
  end 
  
  def comment_model
    Essay::Comment
  end

def prepare_data
    @journals = Journal.events_for_user_feed
    @news = ExpertNews::Post.first 
    
    @project = Core::Project.find(params[:project]) 
    @stage = params[:stage]
end

  def index
    @posts = Essay::Post.where(:stage => params[:stage])    
  end

end
