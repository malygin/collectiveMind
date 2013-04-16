# encoding: utf-8
class Essay::PostsController < PostsController

  def current_model
    Essay::Post
  end 
  
  def comment_model
    Essay::Comment
  end

def prepare_data      
    @project = Core::Project.find(params[:project]) 
    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.first 
    @stage = params[:stage]
end

  def index
    @posts = Essay::Post.where(:stage => params[:stage])    
  end

end
