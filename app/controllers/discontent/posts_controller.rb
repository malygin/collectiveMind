# encoding: utf-8
require 'similar_text'

class Discontent::PostsController < PostsController
  # GET /discontent/posts
  # GET /discontent/posts.json

  autocomplete :discontent_post, :whend, :class_name => 'Discontent::Post' , :full => true
  autocomplete :discontent_post, :whered, :class_name => 'Discontent::Post' , :full => true

  #def get_autocomplete_items(parameters)
  #  items = super(parameters)
  #  items = items.where(:project_id => params[:project])
  #end

  def autocomplete_discontent_post_whend
    render json: Discontent::Post.select("DISTINCT whend as value").where("LOWER(whend) like LOWER(?)", "%#{params[:term]}%").where(:project_id => params[:project])
  end

 def autocomplete_discontent_post_whered
    render json: Discontent::Post.select("DISTINCT whered as value").where("LOWER(whered) like LOWER(?)", "%#{params[:term]}%").where(:project_id => params[:project])
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
    if @project.status == 6 and @project.get_free_votes_for(current_user, :discontent) != 0
      redirect_to action: "vote_list"
      return
    end

    #@post = current_model.new
    @order = params[:order]
    @page = params[:page]
    @folder = :discontent
    @status = 0
    @status = 2 if @project.status == 5
    load_filter_for_aspects   if (request.xhr? and @order.nil? and @page.nil?)

    @posts  = current_model.where(:project_id => @project)
    .where('aspect_id  IN (?) ' , current_user.aspects(@project.id).collect(&:id))
    .where(status: @status)
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
  end


  def vote_list
    @posts = current_model.where(:project_id => @project, :status => 2)
    # i have votes now
    @number_v = @project.get_free_votes_for(current_user, :discontent)
    if @number_v == 0
      redirect_to action: "index"
      return
    end
    @path_for_voting = "/project/#{@project.id}/discontent/"
    #all number of votes
    @votes = @project.stage2
    @status = 2
    #if boss?
    #  @all_people = @project.users.size
    #  @voted_people = ActiveRecord::Base.connection.execute("select count(*) as r from (select distinct v.user_id from life_tape_voitings v  left join   discontent_aspects asp on (v.discontent_aspect_id = asp.id) where asp.project_id = #{@project.id}) as dm").first["r"]
    #  @votes = ActiveRecord::Base.connection.execute("select count(*) as r from (select  v.user_id from life_tape_voitings v  left join   discontent_aspects asp on (v.discontent_aspect_id = asp.id) where asp.project_id = #{@project.id}) as dm").first["r"].to_i
    #end
    render 'vote_list', :layout => 'application_two_column'
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
    #@post = @project.discontents.create(params[name_of_model_for_param])
    #@post.user = current_user
    #discontents = Discontent::Post.where(:project_id => @project.id)
    r=nil
    unless params[:resave]
      r = Discontent::Post.where(:project_id => @project.id, status: 0).collect {|d| [ d, d.content.similar(params[name_of_model_for_param][:content])]}
      r.sort_by!(&:last)
    end
    if r.nil? or  r.last[1] < 20
       @post = @project.discontents.create(params[name_of_model_for_param])
       @post.user = current_user
       @post.save
       current_user.journals.build(:type_event=>name_of_model_for_param+"_save", :project => @project, :body=>"#{@post.content[0..12]}:#{@post.id}").save!
       current_user.add_score(:type => :add_discontent_post, :object => @post)

      # redirect_to  :action=>'show', :id => @post.id, :project => @project
      #return
    else
      @posts = r.collect {|d| d[0] if d[1]> 20}.compact.reverse
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

   def union_discontent
     @project = Core::Project.find(params[:project])
     @post = Discontent::Post.find(params[:id])
     @new_post =Discontent::Post.create(status: 2, project: @project, aspect_id: @post.aspect.id, whered: @post.whered, whend: @post.whend)
     @new_post.save!
     params[:posts].each do |p|
       Discontent::Post.find(p).update_attributes(status: 1, discontent_post_id: @new_post.id)
     end
     @post.update_attributes(status: 1, discontent_post_id: @new_post.id)
     redirect_to discontent_posts_path(@project)
   end

   def unions
     @project = Core::Project.find(params[:project])

     @posts  = current_model.where(:project_id => @project)
     .where('aspect_id  IN (?) ' , current_user.aspects(@project.id).collect(&:id))
     .where(status: 2)
     .order_by_param(@order)
     .paginate(:page => params[:page], :per_page => 20)

     respond_to do |format|
       format.js
     end
   end
end
