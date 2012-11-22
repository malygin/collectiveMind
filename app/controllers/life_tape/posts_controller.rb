# encoding: utf-8
class LifeTape::PostsController < ApplicationController
  # GET /life_tape/posts
  # GET /life_tape/posts.json
  def index
    @life_tape_posts = LifeTape::Post.paginate(:page => params[:page])
    @categories = LifeTape::Category.all
    #todo - improve it too slowly
    top_posts = LifeTape::Post.find(:all, :include => :users).sort_by { |p| p.users.size }
    #@top_posts = LifeTape::Post.joins(:post_voitings).select('life_tape_post_voitings.*, count(user_id) as "user_count"').group(:user_id).order(' user_count desc').limit(3)
    @top_posts = top_posts.reverse[0..3]
  end

  def category
    @category = LifeTape::Category.find(params[:cat_id])
    @life_tape_posts = LifeTape::Post.where(:category_id => params[:cat_id]).paginate(:page => params[:page])
    @categories = LifeTape::Category.all
    render 'index'
  end

  # GET /life_tape/posts/1
  # GET /life_tape/posts/1.json
  def show
    @life_tape_post = LifeTape::Post.find(params[:id])
    @categories = LifeTape::Category.all
    @comment = LifeTape::Comment.new
    puts @life_tape_post.number_views
    @life_tape_post.update_column(:number_views, @life_tape_post.number_views+1)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @life_tape_post }
    end
  end

  def add_comment
    post = LifeTape::Post.find(params[:id])
    unless  params[:life_tape_comment][:content]==""
      post.comments.create(:content => params[:life_tape_comment][:content], :user =>current_user)
      puts params
      flash[:success] = "Комментарий добавлен"
    else
      flash[:success] = "Введите текст комментария"
    end
    redirect_to post

  end

  def plus
    post = LifeTape::Post.find(params[:id])
    post.post_voitings.create(:user => current_user, :post => post, :against => false)
    render json:post.users.count 
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

  def new_child
    @life_tape_post = LifeTape::Post.new
    @categories = LifeTape::Category.all
    @ancestor_id = params[:id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @life_tape_post }
    end

  end

  def create_child
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
    puts params[:id]
    respond_to do |format|
      if @life_tape_post.save
        format.html { redirect_to action: "index" , notice: 'Запись успешно создана!' }
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
