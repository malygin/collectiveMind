# encoding: utf-8
class PostsController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :edit, :update, 
    :plus, :plus_comment, :add_comment, :destroy, :vote_list]
  before_filter :prepare_data, :only => [:index, :new, :edit, :show, :show_essay, 
    :vote_list, :essay_list]
  # before_filter :authorized_user, :only => :destroy

def current_model
	Post
end

def note_model
  PostNote
end

def comment_model
	Comment
end

def name_of_model_for_param
	current_model.table_name.singularize
end

def name_of_comment_for_param
	comment_model.table_name.singularize
end

def root_model_path(project)
    life_tape_posts_path(project)
end

def voting_model  
  Discontent::Post
end

def prepare_data
    @journals = Journal.events_for_user_feed
    @news = ExpertNews::Post.first 
    
    @project = Core::Project.find(params[:project]) 
end

def add_comment
    post = current_model.find(params[:id])
    unless  params[name_of_comment_for_param][:content]==""
      post.comments.create(:content => params[name_of_comment_for_param][:content], :user =>current_user)
      current_user.journals.build(:type_event=>name_of_comment_for_param+"_save", :body=>post.id).save!
      flash[:success] = "Комментарий добавлен"
    else
      flash[:success] = "Введите текст комментария"
    end
    redirect_to post
 end 

def index
    @posts = current_model.where(:project_id => @project)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /discontent/posts/1
  # GET /discontent/posts/1.json
  def show
    @post = current_model.find(params[:id])
    if current_model.column_names.include? :number_views
      @post.update_column(:number_views, @post.number_views+1)
    end
    @comment = comment_model.new  
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  def show_essay
    @post = Essay::Post.find(params[:id])
     @post.update_column(:number_views, @post.number_views+1)

    @comment = Essay::Comment.new  
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /discontent/posts/new
  # GET /discontent/posts/new.json
  def new
    @post = current_model.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /discontent/posts/1/edit
  def edit
    @post = current_model.find(params[:id])
  end

  # POST /discontent/posts
  # POST /discontent/posts.json
  def create
      @project = Core::Project.find(params[:project]) 
      @post = current_model.new(params[name_of_model_for_param])
      @post.project = @project
      @post.user = current_user
      unless params[:stage].nil?
        @post.stage = params[:stage]
      end
      
      unless params[:aspect_id].nil?
        @post.aspect_id = params[:aspect_id]        
      end

      unless params[:replace_id].nil?
        @post.replace_id = params[:replace_id]
        
      end

      if current_model.column_names.include? 'status'
        @post.status = 0
      end
      respond_to do |format|
        if @post.save
          format.html {
            flash[:succes] = 'Успешно добавлено!'
            redirect_to  :action=>'show', :id => @post.id, :project => @project  }
          format.json { render json: @post, status: :created, location: @post }
        else
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    
  end

  # PUT /discontent/posts/1
  # PUT /discontent/posts/1.json
  def update
    @post = current_model.find(params[:id])
    @project = Core::Project.find(params[:project]) 

    respond_to do |format|
      if @post.update_attributes(params[name_of_model_for_param])
        unless params[:aspect_id].nil?
          @post.update_attribute(:aspect_id,params[:aspect_id])        
        end
        format.html { 
          flash[:success] = 'Успешно добавлено!'
          redirect_to  :action=>'show', :project => @project, :id => @post.id}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discontent/posts/1
  # DELETE /discontent/posts/1.json
  def destroy
    @post = current_model.find(params[:id])
    @post.destroy
    @project = Core::Project.find(params[:project]) 

    respond_to do |format|
      format.html { redirect_to root_model_path(@project) }
      format.json { head :no_content }
    end
  end

  def to_archive
    @post = current_model.find(params[:id])
    @post.update_column(:status, 3)

    @project = Core::Project.find(params[:project]) 

    respond_to do |format|
      format.html { redirect_to root_model_path(@project) }
      format.json { head :no_content }
    end
  end

#todo check if user already voted
  def plus
    post = current_model.find(params[:id])
    post.post_voitings.create(:user => current_user, :post => post)
    render json:post.users.count 
  end

  def plus_comment
    comment = comment_model.find(params[:id])
    comment.comment_voitings.create(:user => current_user, :comment => comment)
    render json:comment.users.count 
  end
  
### function for voiting
  #return list model for voiting, check stages
  def vote_list
    @posts = voting_model.where(:project_id => @project)
  end

  def essay_list
    @posts = Essay::Post.where(params[:stage])
    @post = Essay::Post.new
  end

  #write fact of voting in db
  def vote
    v = voting_model.find(params[:post_id])
    v.final_votings.create(:user => current_user)
    render json: 5
  end

### function for dialog with expert


  def to_expert
    prepare_data
    @note = Concept::PostNote.new
  end 

  def expert_rejection
    prepare_data
    @note = Concept::PostNote.new
  end 
  
  def expert_revision
    prepare_data
    @note = Concept::PostNote.new
  end 

  def save_note(params, status, message, type_event)
    puts '______________________________'
    puts params
    post = current_model.find(params[:id])
    if !params[:concept_post_note].nil? and params[:concept_post_note][:content]!= ''
      @note = note_model.new(params[:concept_post_note])
      @note.post = post
      @note.user = current_user
      @note.save
    end
    post.update_column(:status, status)
    # current_user.journals.build(:type_event=>type_event, :body=>concept.id).save!
    flash[:notice]=message
    post
  end

  def to_expert_save
    save_note(params, 1, 'Концепция отправлена эксперту!','concept_post_to_expert' )
    redirect_to  action: "index"    
  end

  def expert_rejection_save
    save_note(params, 3, 'Концепция отклонена!','concept_post_rejection' )
    redirect_to  action: "index"
  end

  def expert_acceptance_save
    concept = save_note(params, 2, 'Концепция принята!','concept_post_acceptance' )
    # concept.user.update_column(:score, concept.user.score + 200)
    redirect_to  action: "index"
  end

  def expert_revision_save
    save_note(params, 0, 'Концепция отправлена на доработку!','concept_post_revision' )
    redirect_to  action: "index"
  end


end
