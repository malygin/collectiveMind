class Discontent::PostsController < PostsController
  # GET /discontent/posts
  # GET /discontent/posts.json
  def current_model
    Discontent::Post
  end 
  
  def comment_model
    Discontent::Comment
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
    puts '________________', @aspect, @aspect!=0
  	if @aspect!='0'
    	@posts = current_model.where(:project_id => @project, :status => 0, :aspect_id => params[:aspect])
    else
      puts 'aspect!!!!! == 0'
    	@posts = current_model.where(:project_id => @project, :status => @status)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

end
