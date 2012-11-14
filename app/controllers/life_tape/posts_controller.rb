# encoding: utf-8
class LifeTape::PostsController < ApplicationController
  # GET /life_tape/posts
  # GET /life_tape/posts.json
  def index
    @life_tape_posts = LifeTape::Post.all
    @categories = LifeTape::Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @life_tape_posts }
    end
  end

  # GET /life_tape/posts/1
  # GET /life_tape/posts/1.json
  def show
    @life_tape_post = LifeTape::Post.find(params[:id])
    @categories = LifeTape::Category.all
    @comment = LifeTape::Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @life_tape_post }
    end
  end

  def add_comment
    post = LifeTape::Post.find(params[:id])
    post.comments.create(:content => params[:life_tape_comment][:content], :user =>current_user)
    puts params
    flash[:success] = "Комментарий добавлен"
    redirect_to post

  end

  # GET /life_tape/posts/new
  # GET /life_tape/posts/new.json
  def new
    @life_tape_post = LifeTape::Post.new
    @categories = LifeTape::Category.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @life_tape_post }
    end
  end

  # GET /life_tape/posts/1/edit
  def edit
    @life_tape_post = LifeTape::Post.find(params[:id])
  end

  # POST /life_tape/posts
  # POST /life_tape/posts.json
  def create
    @life_tape_post = LifeTape::Post.new(params[:life_tape_post])
    @life_tape_post.user = current_user
    @life_tape_post.category_id =  params[:category]
    respond_to do |format|
      if @life_tape_post.save
        format.html { redirect_to action: "index" , notice: 'Post was successfully created.' }
        format.json { render json: @life_tape_post, status: :created, location: @life_tape_post }
      else
        format.html { render action: "new" }
        format.json { render json: @life_tape_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /life_tape/posts/1
  # PUT /life_tape/posts/1.json
  def update
    @life_tape_post = LifeTape::Post.find(params[:id])

    respond_to do |format|
      if @life_tape_post.update_attributes(params[:life_tape_post])
        format.html { redirect_to @life_tape_post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @life_tape_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /life_tape/posts/1
  # DELETE /life_tape/posts/1.json
  def destroy
    @life_tape_post = LifeTape::Post.find(params[:id])
    @life_tape_post.destroy

    respond_to do |format|
      format.html { redirect_to life_tape_posts_url }
      format.json { head :no_content }
    end
  end
end
