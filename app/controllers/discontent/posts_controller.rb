class Discontent::PostsController < PostsController
  # GET /discontent/posts
  # GET /discontent/posts.json
  def current_model
    Discontent::Post
  end 
  
  def comment_model
    Discontent::Comment
  end

  def note_model
    Discontent::PostNote
  end

  def voting_model  
    Discontent::Post
  end

  def prepare_data
    @project = Core::Project.find(params[:project]) 
    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.where(:project_id => @project).first 
    @status = params[:status]
    @aspect = params[:aspect]
    @aspects = Discontent::Aspect.where(:project_id => @project, :status => 1)
end

  def index
  	if @aspect!='0'
    	@posts = current_model.where(:project_id => @project, :status => 0, :aspect_id => params[:aspect]).paginate(:page => params[:page])
    else
    	@posts = current_model.where(:project_id => @project, :status => @status).paginate(:page => params[:page])
    end
    if @status == '2'
      if @project.status == 4
          @number_v = @project.stage2 - current_user.voted_discontent_posts.size
          @votes = @project.stage2
      end
      render 'table', :layout => 'application_two_column'
    else
      render 'index'
    end
  end

 def new
    prepare_data
    @post = current_model.new
    unless params[:replace_id].nil?
      @replace_post = current_model.find(params[:replace_id])
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end



  def vote_list
    @posts = current_model.where(:project_id => @project, :status => 2)
    # i have votes now
    @number_v = @project.stage2 - current_user.voted_discontent_posts.size
    @path_for_voting = "/project/#{@project.id}/discontent/"
    #all number of votes
    @votes = @project.stage2
  end
  def my
    prepare_data
    @posts = current_model.where(:project_id => @project, :status => 0, :user_id => current_user).where("created_at < ?", 2.day.ago)
    @posts2 = current_model.where(:project_id => @project, :status => 0, :user_id => current_user).where("created_at >= ?", 2.day.ago)
    @review_posts = current_model.where(:project_id => @project, :status => 1, :user_id => current_user)
    @accepted_posts = current_model.where(:project_id => @project, :status => 2, :user_id => current_user)
  end
end
