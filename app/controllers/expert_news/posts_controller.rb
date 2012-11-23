# encoding: utf-8

class ExpertNews::PostsController < ApplicationController
  # GET /expert_news/posts
  # GET /expert_news/posts.json
  def index
    @expert_news_posts = ExpertNews::Post.order('created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @expert_news_posts }
    end
  end

  # GET /expert_news/posts/1
  # GET /expert_news/posts/1.json
  def show
    @expert_news_post = ExpertNews::Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @expert_news_post }
    end
  end

  # GET /expert_news/posts/new
  # GET /expert_news/posts/new.json
  def new
    @expert_news_post = ExpertNews::Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expert_news_post }
    end
  end

  # GET /expert_news/posts/1/edit
  def edit
    @expert_news_post = ExpertNews::Post.find(params[:id])
  end

  # POST /expert_news/posts
  # POST /expert_news/posts.json
  def create
    @expert_news_post = ExpertNews::Post.new(params[:expert_news_post])
    @expert_news_post.user = current_user

    respond_to do |format|
      if @expert_news_post.save
        format.html { redirect_to @expert_news_post, notice: 'новость или комментарий добавлены.' }
        format.json { render json: @expert_news_post, status: :created, location: @expert_news_post }
      else
        format.html { render action: "new" }
        format.json { render json: @expert_news_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /expert_news/posts/1
  # PUT /expert_news/posts/1.json
  def update
    @expert_news_post = ExpertNews::Post.find(params[:id])

    respond_to do |format|
      if @expert_news_post.update_attributes(params[:expert_news_post])
        format.html { redirect_to @expert_news_post, notice: 'Редактирование успешно.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @expert_news_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expert_news/posts/1
  # DELETE /expert_news/posts/1.json
  def destroy
    @expert_news_post = ExpertNews::Post.find(params[:id])
    @expert_news_post.destroy

    respond_to do |format|
      format.html { redirect_to expert_news_posts_url }
      format.json { head :no_content }
    end
  end
end
