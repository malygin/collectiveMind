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

  def index
    @posts_user = LifeTape::Post.includes(:user).where(:project_id => @project).where("users.admin = ? and users.expert = ?", false, false)
    @posts_facil = LifeTape::Post.includes(:user).where(:project_id => @project).where("users.admin = ? or users.expert = ?", true, true)
    @aspects = Discontent::Aspect.where(:project_id => @project)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

end
