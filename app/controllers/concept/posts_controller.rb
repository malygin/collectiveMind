# encoding: utf-8

class Concept::PostsController < PostsController
  # GET /discontent/posts
  # GET /discontent/posts.json
   layout 'life_tape/posts2', :only => [:new, :edit, :show]
  def current_model
    Concept::Post
  end
  
  def comment_model
    Concept::Comment
  end

  def note_model
    Concept::PostNote
  end

  def voting_model  
    Concept::Post
  end

  def prepare_data
    @project = Core::Project.find(params[:project]) 
    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.first  
    @status = params[:status]
  end


  def index
    @posts = current_model.where(:project_id => @project, :status => @status).paginate(:page => params[:page])
    if @status == '2'
      #if @project.status == 6
        @number_v = @project.stage3 - current_user.voted_discontent_posts.size
        @votes = @project.stage3
        @discontents = Discontent::Post.where(:project_id => @project, :status =>[2,5])
      #end
      render 'table', :layout => 'application_two_column'
    else
      render 'index'
    end
  end

  def create
    @project = Core::Project.find(params[:project])
    @concept_post = Concept::Post.new(params[:concept_post])
    @concept_post.number_views =0
    @concept_post.user = current_user
    @concept_post.status = 0
    @concept_post.project = @project

    unless params['correct_disc'].nil?
      params['correct_disc'].each do |v|
        if v!= ''

          unless Discontent::Post.exists?(v[0])
            disc = Discontent::Post.new(v[1]['disc'])
            disc.status = 5
            disc.project = params[:project]
            disc.user = current_user
            disc.save!
            v[1].delete :disc
            @concept_post.post_aspects.build(v[1].merge :discontent_aspect_id=> disc.id)
          else
            v[1].delete :disc
            @concept_post.post_aspects.build(v[1].merge :discontent_aspect_id=> v[0])
          end

        end
      end
    end
    #
    respond_to do |format|
      if @concept_post.save!
         current_user.journals.build(:type_event=>'concept_post_save', :body=>@concept_post.id).save!
        format.html { redirect_to  action: "index" , notice: 'Образ добавлен!' }
        format.json { render json: @concept_post, status: :created, location: @concept_post }
      else
        format.html { render action: "new" }
        format.json { render json: @concept_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /concept/posts/1
  # PUT /concept/posts/1.json
  def update
    @project = Core::Project.find(params[:project])

    @concept_post = Concept::Post.find(params[:id])
    @concept_post.update_attributes(params[:concept_post])
    @concept_post.post_aspects.destroy_all
    unless params['correct_disc'].nil?
      params['correct_disc'].each do |v|
        if v!= ''
          @concept_post.post_aspects.build(v[1].merge :discontent_aspect_id=> v[0])

        end
      end
    end

    respond_to do |format|
      if @concept_post.save!
        current_user.journals.build(:type_event=>'concept_post_update', :body=>@concept_post.id).save!

        format.html { redirect_to action: "show", :project => @project, :id => @concept_post.id , notice: 'Концепция успешно изменена!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @concept_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def vote_list
    @posts = current_model.where(:project_id => @project, :status => 2)
    # i have votes now
    @number_v = @project.stage3 - current_user.voted_concept_posts.size
    @path_for_voting = "/project/#{@project.id}/concept/vote/"
    #all number of votes
    @votes = @project.stage3
  end

  def new
    @post = current_model.new
    @discontent_post = Discontent::Post.new
    @aspects = Discontent::Aspect.where(:project_id => @project)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

   def edit
     @post = current_model.find(params[:id])
     @aspects = Discontent::Aspect.where(:project_id => @project)

   end

  def add_aspect
    
    @aspect = Discontent::Aspect.find(params[:aspect_id]) 
    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

   def add_new_discontent
     @discontent = Discontent::Post.new
     @discontent.id = (0..10).map{rand(0..10)}.join
     @aspects = Discontent::Aspect.where(:project_id =>params[:project])
     respond_to do |format|
       format.js
     end

   end

  
end
