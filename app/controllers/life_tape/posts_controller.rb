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
 @aspects = Discontent::Aspect.where(:project_id => @project)
    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.first 
    
end

  # def index
  #   @posts_user = LifeTape::Post.includes(:user).where(:project_id => @project).where("users.admin = ? and users.expert = ?", false, false)
  #   @posts_facil = LifeTape::Post.includes(:user).where(:project_id => @project).where("users.admin = ? or users.expert = ?", true, true)
  #   @aspects = Discontent::Aspect.where(:project_id => @project)
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @posts }
  #   end
  # end
  def vote_list
    @posts = voting_model.where(:project_id => @project)
    @number_v = @project.stage1.to_i - current_user.voted_aspects.size
    @path_for_voting = "/project/#{@project.id}/life_tape/vote/"
     @votes = @project.stage1

  end

end
