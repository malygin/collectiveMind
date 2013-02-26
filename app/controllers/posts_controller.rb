# encoding: utf-8
class PostsController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :edit, :update, 
    :plus, :plus_comment, :add_comment, :destroy]
  before_filter :prepare_data, :only => [:index, :new, :edit, :show]
  before_filter :authorized_user, :only => :destroy

def current_model
	Post
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

def prepare_data
    @journals = Journal.events_for_user_feed
    @news = ExpertNews::Post.first 
    puts params
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
  	prepare_data
    @post = current_model.find(params[:id])
    @post.update_column(:number_views, @post.number_views+1)
    @comment = comment_model.new
  
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
    @post = current_model.new(params[name_of_model_for_param])
    @project = Core::Project.find(params[:project]) 
    @post.project = @project
    @post.user = current_user
    respond_to do |format|
      if @post.save
        format.html {
          flash[:notice] = 'Success!'
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

        format.html { 
          flash[:notice] = 'Success!'
          redirect_to  :action=>'show', :project => @project }
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

    respond_to do |format|
      format.html { redirect_to posts_url }
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
  
end
