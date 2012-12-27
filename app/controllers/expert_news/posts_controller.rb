# encoding: utf-8

class ExpertNews::PostsController < ApplicationController
  # GET /expert_news/posts
  # GET /expert_news/posts.json
  def prepare_data
    @journals = Journal.events_for_user_feed
    @news = ExpertNews::Post.first    
  end
  def index
    @expert_news_posts = ExpertNews::Post.order('created_at DESC')
    prepare_data
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @expert_news_posts }
    end
  end

  # GET /expert_news/posts/1
  # GET /expert_news/posts/1.json
  def show
    prepare_data
    @expert_news_post = ExpertNews::Post.find(params[:id])
    @comment = ExpertNews::Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @expert_news_post }
    end
  end

  # GET /expert_news/posts/new
  # GET /expert_news/posts/new.json
  def new
    prepare_data
    @expert_news_post = ExpertNews::Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expert_news_post }
    end
  end

  # GET /expert_news/posts/1/edit
  def edit
    prepare_data
    @expert_news_post = ExpertNews::Post.find(params[:id])
  end

  # POST /expert_news/posts
  # POST /expert_news/posts.json
  def create
    @expert_news_post = ExpertNews::Post.new(params[:expert_news_post])
    @expert_news_post.user = current_user

    respond_to do |format|
      if @expert_news_post.save
        current_user.journals.build(:type_event=>'news_post_save', :body=>@expert_news_post.id).save!
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
    #todo union method for all comments and partials
  def add_comment
    post = ExpertNews::Post.find(params[:id])
    unless  params[:expert_news_comment][:content]==""
      post.comments.create(:content => params[:expert_news_comment][:content], :user =>current_user)
      current_user.journals.build(:type_event=>'news_comment_save', :body=>post.id).save!
      flash[:success] = "Комментарий добавлен"
    else
      flash[:success] = "Введите текст комментария"
    end
    redirect_to post

  end
end
