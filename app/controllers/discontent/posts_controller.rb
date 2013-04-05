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

  def prepare_data
    @journals = Journal.events_for_user_feed
    @news = ExpertNews::Post.first  
    @project = Core::Project.find(params[:project]) 
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
    @replace_post = current_model.find(params[:replace_id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

end
