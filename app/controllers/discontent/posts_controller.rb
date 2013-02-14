class Discontent::PostsController < ApplicationController
  # GET /discontent/posts
  # GET /discontent/posts.json
  def index
    @discontent_posts = Discontent::Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @discontent_posts }
    end
  end

  # GET /discontent/posts/1
  # GET /discontent/posts/1.json
  def show
    @discontent_post = Discontent::Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discontent_post }
    end
  end

  # GET /discontent/posts/new
  # GET /discontent/posts/new.json
  def new
    @discontent_post = Discontent::Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @discontent_post }
    end
  end

  # GET /discontent/posts/1/edit
  def edit
    @discontent_post = Discontent::Post.find(params[:id])
  end

  # POST /discontent/posts
  # POST /discontent/posts.json
  def create
    @discontent_post = Discontent::Post.new(params[:discontent_post])
    @discontent_post.user = current_user
    respond_to do |format|
      if @discontent_post.save
        format.html { redirect_to @discontent_post, notice: 'Post was successfully created.' }
        format.json { render json: @discontent_post, status: :created, location: @discontent_post }
      else
        format.html { render action: "new" }
        format.json { render json: @discontent_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /discontent/posts/1
  # PUT /discontent/posts/1.json
  def update
    @discontent_post = Discontent::Post.find(params[:id])

    respond_to do |format|
      if @discontent_post.update_attributes(params[:discontent_post])
        format.html { redirect_to @discontent_post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @discontent_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discontent/posts/1
  # DELETE /discontent/posts/1.json
  def destroy
    @discontent_post = Discontent::Post.find(params[:id])
    @discontent_post.destroy

    respond_to do |format|
      format.html { redirect_to discontent_posts_url }
      format.json { head :no_content }
    end
  end
end
