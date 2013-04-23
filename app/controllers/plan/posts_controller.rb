# encoding: utf-8

class Plan::PostsController < PostsController


 layout 'life_tape/posts2', :only => [:new, :edit, :show]
  def current_model
    Plan::Post
  end 
  def comment_model
    Plan::Comment
  end

  def note_model
    Plan::PostNote
  end

  def voting_model  
    Plan::Post
  end

  def prepare_data
    @project = Core::Project.find(params[:project]) 
    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.first  
    @status = params[:status]
  end


  def index
    @posts = current_model.where(:project_id => @project, :status => @status).paginate(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end
  def create
        @project = Core::Project.find(params[:project]) 

    @plan_post = Plan::Post.new(params[:plan_post])
    # unless params['idea'].nil?
    #   @plan_post.life_tape_post_id = params['idea']
    # end
    @plan_post.number_views =0
    @plan_post.project = @project
    @plan_post.user = current_user
    @plan_post.status = 0
    @plan_post.task_triplets = []
    #puts params['task_supply']
    position=1
    params['task_triplet'].each do |k,v|
      if v!= ''
        triplet = Plan::TaskTriplet.new(:task => v, :position => position) 
        position+=1
        @plan_post.task_triplets << triplet
      end
    end

    respond_to do |format|
      if @plan_post.save!
         current_user.journals.build(:type_event=>'plan_post_save', :body=>@plan_post.id).save!
        format.html { redirect_to  action: "index" , notice: 'Проект добавлен!' }
        format.json { render json: @plan_post, status: :created, location: @plan_post }
      else
        format.html { render action: "new" }
        format.json { render json: @plan_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /Plan/posts/1
  # PUT /Plan/posts/1.json
  def update
    @project = Core::Project.find(params[:project]) 

    @plan_post = Plan::Post.find(params[:id])
    respond_to do |format|
      if @plan_post.update_attributes(params[:plan_post])
         @plan_post.task_triplets =[]
         unless params['task_triplet'].nil?
          position=1

          params['task_triplet'].each do |k,v|
            if k!= ''
              triplet = Plan::TaskTriplet.new(:task => v, :position => position) 
              position+=1
              @plan_post.task_triplets << triplet
            end
          end   
         end
         
        @plan_post.save
        current_user.journals.build(:type_event=>'plan_post_update', :body=>@plan_post.id).save!

        format.html {  redirect_to action: "show", :project => @project, :id => @plan_post.id, notice: 'Проект успешно изменен!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plan_post.errors, status: :unprocessable_entity }
      end
    end
  end



end
