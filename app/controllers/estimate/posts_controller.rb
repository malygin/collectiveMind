class Estimate::PostsController < ApplicationController
  # GET /estimate/posts
  # GET /estimate/posts.json
  def index
    @estimate_posts = Estimate::Post.all
    @plan_posts = Plan::Post.find(:status => '3')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @estimate_posts }
    end
  end

  # GET /estimate/posts/1
  # GET /estimate/posts/1.json
  def show
    @estimate_post = Estimate::Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @estimate_post }
    end
  end

  # GET /estimate/posts/new
  # GET /estimate/posts/new.json
  def new
    @estimate_post = Estimate::Post.new
    @plan_post = Plan::Post.find(params[:post_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @estimate_post }
    end
  end

  # GET /estimate/posts/1/edit
  def edit
    @estimate_post = Estimate::Post.find(params[:id])
  end

  # POST /estimate/posts
  # POST /estimate/posts.json
  def create
    @estimate_post = Estimate::Post.new(params[:estimate_post])

    respond_to do |format|
      if @estimate_post.save
        format.html { redirect_to @estimate_post, notice: 'Post was successfully created.' }
        format.json { render json: @estimate_post, status: :created, location: @estimate_post }
      else
        format.html { render action: "new" }
        format.json { render json: @estimate_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /estimate/posts/1
  # PUT /estimate/posts/1.json
  def update
    @estimate_post = Estimate::Post.find(params[:id])

    respond_to do |format|
      if @estimate_post.update_attributes(params[:estimate_post])
        format.html { redirect_to @estimate_post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @estimate_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /estimate/posts/1
  # DELETE /estimate/posts/1.json
  def destroy
    @estimate_post = Estimate::Post.find(params[:id])
    @estimate_post.destroy

    respond_to do |format|
      format.html { redirect_to estimate_posts_url }
      format.json { head :no_content }
    end
  end
end
