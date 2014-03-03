# encoding: utf-8
class Discontent::PostsController < PostsController
  # GET /discontent/posts
  # GET /discontent/posts.json

  autocomplete :discontent_post, :whend, :class_name => 'Discontent::Post' , :full => true
  autocomplete :discontent_post, :whered, :class_name => 'Discontent::Post' , :full => true

  def get_autocomplete_items(parameters)
    items = super(parameters)
    items = items.where(:project_id => params[:project])
  end



  def voting_model  
    Discontent::Post
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
    add_breadcrumb I18n.t('stages.discontent'), discontent_posts_path(@project)

    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.where(:project_id => @project).first 
    @status = params[:status]
    @aspect = params[:aspect]
    @aspects = Discontent::Aspect.where(:project_id => @project)

    @post_star =[]
    #Discontent::Post.where(:project_id => @project, :important => 't' ).limit(3)
    @post_dis = Discontent::Post.
        where(:project_id => @project).
        reorder('number_views DESC').
        limit(3)
  end

  def index

    @post = current_model.new
    @order = params[:order]
    @page = params[:page]
    @folder = :discontent
    load_filter_for_aspects   if (request.xhr? and @order.nil? and @page.nil?)

    @posts  = current_model.where(:project_id => @project)
    .where('aspect_id  IN (?) ' , current_user.aspects(@project.id).collect(&:id))
    .order_by_param(@order)
    .paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html {
       if params[:view] == 'table'
         render  'table', layout: 'application_two_column'
       end
      }
      format.js {render 'posts/index'}
    end
  end

 def new

    @post = current_model.new
    @replace_posts =[]
    @accepted_posts = Discontent::Post.where(status: 2, project_id:  @project)

    unless params[:replace_id].nil?
      @replace_posts << current_model.find(params[:replace_id])
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /discontent/posts/1/edit
  def edit
    @post = current_model.find(params[:id])
    @replace_posts = @post.post_replaced
    @accepted_posts = Discontent::Post.where(status: 2, project_id:  @project )
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

    @posts = current_user.discontent_posts.for_project(@project.id).ready_for_post
    @posts2 =  current_user.discontent_posts.for_project(@project.id).not_ready_for_post
    @review_posts = current_user.discontent_posts.for_project(@project.id).for_expert
    @accepted_posts = current_user.discontent_posts.for_project(@project.id).accepted
    @achived_posts =current_user.discontent_posts.for_project(@project.id).archive
    render 'my', :layout => 'application_two_column'
  end

  def create
    @project = Core::Project.find(params[:project])
    @post = @project.discontents.create(params[name_of_model_for_param])
    @post.user = current_user

    respond_to do |format|
      if @post.save
        current_user.journals.build(:type_event=>name_of_model_for_param+"_save", :project => @project, :body=>"#{@post.content[0..12]}:#{@post.id}").save!

        format.html {
          unless params[:replace].nil?
            params[:replace].each do |k,v|
              @post.post_replaces.build(:replace_id => k).save
            end
          end
          flash[:succes] = 'Успешно добавлено!'

          redirect_to  :action=>'show', :id => @post.id, :project => @project  }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.js
      end
    end

  end
end
