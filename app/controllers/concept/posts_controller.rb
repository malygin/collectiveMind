# encoding: utf-8

class Concept::PostsController < ApplicationController
  # GET /concept/posts
  # GET /concept/posts.json
    before_filter :authenticate, :only => [:create, :new]

  def index
    @concept_posts = Concept::Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @concept_posts }
    end
  end

  # GET /concept/posts/1
  # GET /concept/posts/1.json
  def show
    @concept_post = Concept::Post.find(params[:id])
    @concept_post.update_column(:number_views, @concept_post.number_views+1)

    @comment = Concept::Comment.new
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @concept_post }
    end
  end
  #todo union method for all comments and partials
  def add_comment
    post = Concept::Post.find(params[:id])
    unless  params[:concept_comment][:content]==""
      post.comments.create(:content => params[:concept_comment][:content], :user =>current_user)
      current_user.journals.build(:type_event=>'concept_comment_save', :body=>post.id).save!
      flash[:success] = "Комментарий добавлен"
    else
      flash[:success] = "Введите текст комментария"
    end
    redirect_to post

  end

  # GET /concept/posts/new
  # GET /concept/posts/new.json
  def new
    @concept_post = Concept::Post.new
    @concept_post.task_supply_pairs << Concept::TaskSupplyPair.new(:task =>'', :supply => '')
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @concept_post }
    end
  end

  # GET /concept/posts/1/edit
  def edit
    @concept_post = Concept::Post.find(params[:id])
    @task_supply = @concept_post.task_supply_pairs
  end

  # POST /concept/posts
  # POST /concept/posts.json
  def create
    @concept_post = Concept::Post.new(params[:concept_post])
    @concept_post.number_views =0
    @concept_post.user = current_user
    #@concept_post.task_supply_pairs = nil
    #puts params['task_supply']
    params['task_supply'].each do |k,v|
      if v['1']!= '' or v['2']!= ''
        pair = Concept::TaskSupplyPair.new(:task => v['1'], :supply => v['2']) 
        @concept_post.task_supply_pairs << pair
      end
    end

    respond_to do |format|
      if @concept_post.save
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
         params['task_supply'].each do |k,v|
          if v['1']!= '' or v['2']!= ''
            pair = Concept::TaskSupplyPair.new(:task => v['1'], :supply => v['2']) 
            @concept_post.task_supply_pairs << pair
          end
        end
        @concept_post.save
        format.html { redirect_to @concept_post, notice: 'Концепция успешно изменена!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @concept_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /concept/posts/1
  # DELETE /concept/posts/1.json
  def destroy
    @concept_post = Concept::Post.find(params[:id])
    @concept_post.destroy

    respond_to do |format|
      format.html { redirect_to concept_posts_url }
      format.json { head :no_content }
    end
  end
end
