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
    @news = ExpertNews::Post.first  
    @status = params[:status]
    @aspect = params[:aspect]
    @aspects = Discontent::Aspect.all
end

  def index
  	if @aspect!='0'
    	@posts = current_model.where(:project_id => @project, :status => 0, :aspect_id => params[:aspect])
    else
    	@posts = current_model.where(:project_id => @project, :status => @status)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
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
    @path_for_voting = "/project/#{@project.id}/discontent/vote/"
    #all number of votes
    @votes = @project.stage2
  end

end
