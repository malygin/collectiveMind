# encoding: utf-8
class LifeTape::PostsController < PostsController


  def current_model
    LifeTape::Post
  end 
  
  def comment_model
    LifeTape::Comment
  end

  def voting_model
    Discontent::Aspect
  end
  
def prepare_data
    @project = Core::Project.find(params[:project]) 
    @aspects = Discontent::Aspect.unscoped.order("position").where(:project_id => @project)
    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.where(:project_id => @project).first 
    
end

  def index
    if params[:aspect].nil?
      @posts = current_model.where(:project_id => @project).paginate(:page => params[:page])

    else
      @posts = current_model.where(:project_id => @project, :aspect_id => params[:aspect]).paginate(:page => params[:page])

    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end
  def vote_list
    @posts = voting_model.where(:project_id => @project)
    @number_v = @project.stage1.to_i - current_user.voted_aspects.size
    @path_for_voting = "/project/#{@project.id}/life_tape/"
     @votes = @project.stage1
  end

end
