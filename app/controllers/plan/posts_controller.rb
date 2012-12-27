class Plan::PostsController < ApplicationController
  # GET /plan/posts
  # GET /plan/posts.json
  def index
    @plan_posts = Plan::Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plan_posts }
    end
  end

  # GET /plan/posts/1
  # GET /plan/posts/1.json
  def show
    @plan_post = Plan::Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plan_post }
    end
  end

  # GET /plan/posts/new
  # GET /plan/posts/new.json
  def new
    @plan_post = Plan::Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plan_post }
    end
  end

  # GET /plan/posts/1/edit
  def edit
    @plan_post = Plan::Post.find(params[:id])
  end

  # POST /plan/posts
  # POST /plan/posts.json
  def create
    @plan_post = Plan::Post.new(params[:plan_post])

    respond_to do |format|
      if @plan_post.save
        format.html { redirect_to @plan_post, notice: 'Post was successfully created.' }
        format.json { render json: @plan_post, status: :created, location: @plan_post }
      else
        format.html { render action: "new" }
        format.json { render json: @plan_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /plan/posts/1
  # PUT /plan/posts/1.json
  def update
    @plan_post = Plan::Post.find(params[:id])

    respond_to do |format|
      if @plan_post.update_attributes(params[:plan_post])
        format.html { redirect_to @plan_post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plan_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plan/posts/1
  # DELETE /plan/posts/1.json
  def destroy
    @plan_post = Plan::Post.find(params[:id])
    @plan_post.destroy

    respond_to do |format|
      format.html { redirect_to plan_posts_url }
      format.json { head :no_content }
    end
  end
end
