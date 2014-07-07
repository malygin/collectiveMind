# encoding: utf-8
class Essay::PostsController < PostsController
  layout 'application_two_column', :only => [:new, :edit, :show, :index]
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
    @posts = Essay::Post.where(:project_id => @project, :stage => @stage, :status => 0 )
    respond_to do |format|
      format.html{render :layout  => 'application_two_column'}
    end
  end

end
