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
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def create
    @project = Core::Project.find(params[:project]) 

    @concept_post = Concept::Post.new(params[:concept_post])
    puts '__________-', params
    unless params['idea'].nil?
      @concept_post.life_tape_post_id = params['idea']
    end
    @concept_post.number_views =0
    @concept_post.user = current_user
    @concept_post.status = 0
          @concept_post.project = @project

    #@concept_post.task_supply_pairs = nil
    #puts params['task_supply']
    unless params['task_supply'].nil?
      params['task_supply'].each do |k,v|
        if v['1']!= '' or v['2']!= ''
          pair = Concept::TaskSupplyPair.new(:task => v['1'], :supply => v['2']) 
          @concept_post.task_supply_pairs << pair
        end
      end
    end

    respond_to do |format|
      if @concept_post.save!
         current_user.journals.build(:type_event=>'concept_post_save', :body=>@concept_post.id).save!
        format.html { redirect_to  action: "index" , notice: 'Концепция добавлена!' }
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
    @concept_post = Concept::Post.find(params[:id])
    respond_to do |format|
      if @concept_post.update_attributes(params[:concept_post])
         @concept_post.task_supply_pairs =[]
         unless params['task_supply'].nil?
          params['task_supply'].each do |k,v|
            if v['1']!= '' or v['2']!= ''
              pair = Concept::TaskSupplyPair.new(:task => v['1'], :supply => v['2']) 
              @concept_post.task_supply_pairs << pair
            end
          end           
         end
         
        @concept_post.save
        current_user.journals.build(:type_event=>'concept_post_update', :body=>@concept_post.id).save!

        format.html { redirect_to @concept_post, notice: 'Концепция успешно изменена!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @concept_post.errors, status: :unprocessable_entity }
      end
    end
  end

 
  
end
