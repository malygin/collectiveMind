# encoding: utf-8

class Concept::PostsController < ApplicationController
  # GET /concept/posts
  # GET /concept/posts.json
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @concept_post }
    end
  end

  # GET /concept/posts/new
  # GET /concept/posts/new.json
  def new
    @concept_post = Concept::Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @concept_post }
    end
  end

  # GET /concept/posts/1/edit
  def edit
    @concept_post = Concept::Post.find(params[:id])
  end

  # POST /concept/posts
  # POST /concept/posts.json
  def create
    @concept_post = Concept::Post.new(params[:concept_post])
    @concept_posts.user = current_user
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
        format.html { redirect_to @concept_post, notice: 'Post was successfully updated.' }
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
