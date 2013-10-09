# encoding: utf-8
class PostsController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :edit, :update, 
    :plus, :plus_comment, :add_comment, :destroy, :vote_list]
  before_filter :prepare_data, :only => [:index, :new, :edit, :show, :show_essay, 
    :vote_list, :essay_list]
  before_filter :have_rights

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
    @project = Core::Project.find(params[:project]) 

    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.where(:project_id => @project).first 
    
end

def add_comment
    @project = Core::Project.find(params[:project]) 
    post = current_model.find(params[:id])
    unless  params[name_of_comment_for_param][:content]==''
      comment = post.comments.create(:content => params[name_of_comment_for_param][:content], :user =>current_user)
      current_user.journals.build(:type_event=>name_of_comment_for_param+'_save', :project => @project, :body=>"#{post.id}#comment_#{comment.id}").save!
      flash[:success] = 'Комментарий добавлен'
    else
      flash[:success] = 'Введите текст комментария'
    end
    redirect_to polymorphic_path(post, :project => @project.id)
 end 

def index
    @posts = current_model.where(:project_id => @project).paginate(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /discontent/posts/1
  # GET /discontent/posts/1.json
  def show
    @post = current_model.where(:id => params[:id], :project_id => params[:project]).first
    @comments = @post.comments.paginate(:page => params[:page], :per_page => 30)
    #puts "___________"
    #puts @post
    # @path_link ='/'+ self.class.to_s.split("::").first.tableize.singularize+'/comments/'

    if current_model.column_names.include? 'number_views'
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
      unless params[:style].nil?
        @post.style = params[:style]
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
            current_user.journals.build(:type_event=>name_of_model_for_param+"_save", :project => @project, :body=>@post.id).save!

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
        unless params[:style].nil?
          @post.update_attribute(:style,params[:style])
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
    post.post_votings.create(:user => current_user, :post => post)
    render json:post.users.count 
  end

  def plus_comment
    comment = comment_model.find(params[:id])
    comment.comment_votings.create(:user => current_user, :comment => comment)
    if  self.current_model  == Discontent::Post
      if comment.comment_votings.count == 3 or current_user.boss?
        comment.user.add_score(20,:score_a)
        @project = Core::Project.find(params[:project])
        comment.user.journals.build(:type_event=>'add_score_anal', :project => @project, :body=>"#{comment.post.id}#comment_#{comment.id}").save!
      end
    end
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

   def up
    v = voting_model.find(params[:post_id])
    v.update_column(:status, v.status+1)
    render json: 5

   end

   def down
    v = voting_model.find(params[:post_id])
    v.update_column(:status, v.status-1)
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

    post = current_model.find(params[:id])
    if !params[:concept_post_note].nil? and params[:concept_post_note][:content]!= ''
      @note = note_model.new(params[:concept_post_note])
      @note.post = post
      @note.user = current_user
      @note.save
    end
    post.update_column(:status, status)
    current_user.journals.build(:type_event=>type_event,  :project => Core::Project.find(params[:project]), :body=>post.id).save!
    flash[:notice]=message
    post
  end

  def to_expert_save
    save_note(params, 1, 'Отправлено эксперту!','discontent_post_to_expert' )
    redirect_to  action: "index"    
  end

  def expert_rejection_save
    save_note(params, 3, 'Отклонено!','discontent_post_rejection' )
    redirect_to  action: "index"
  end

  def expert_acceptance_save
    post = save_note(params, 2, 'Принято!','discontent_post_acceptance' )
    if post.post.nil?
      post.user.add_score(100)
      #post.user.update_column(:score, post.user.score + 100)
      #post.user.update_column(:score_g, post.user.score_g + 100)
    else
      post.user.add_score(200)

      #post.user.update_column(:score, post.user.score + 200)
      #post.user.update_column(:score_g, post.user.score_g + 200)
      post.post.update_column(:status, 3)
    end
    redirect_to  action: "index"
  end

  def expert_revision_save
    save_note(params, 0, 'Отправлена на доработку!','discontent_post_revision' )
    redirect_to  action: "index"
  end

  def censored
    if boss?
      post = current_model.find(params[:post_id])
      post.update_column(:censored, true)
    end
  end

  def censored_comment
    if boss?
      comment = comment_model.find(params[:id])
      comment.update_column(:censored, true)
    end
  end

end
