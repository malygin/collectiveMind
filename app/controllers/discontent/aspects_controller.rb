class Discontent::AspectsController  < ApplicationController
  # GET /discontent/posts
  # GET /discontent/posts.json
  def current_model
    Discontent::Aspect
  end

  def edit
    @project = Core::Project.find(params[:project])
    @aspect = Discontent::Aspect.find(params[:id])
  end

  def update
    @aspect = Discontent::Aspect.find(params[:id])
    @aspect.update_attributes( params[:discontent_aspect])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def destroy
    @project = Core::Project.find(params[:project])
    @aspect = Discontent::Aspect.find(params[:id])
    @aspect.update_attributes(:status => 1)
    respond_to do |format|
      format.js
    end
    #@aspect.destroy if current_user.boss?
    #@aspect.life_tape_posts.destroy_all if current_user.boss?
    #@aspect.life_tape_posts.first.destroy if current_user.boss?
    #redirect_to life_tape_posts_path(@project)
  end

  def new
    @project = Core::Project.find(params[:project])
    @aspect = Discontent::Aspect.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @project = Core::Project.find(params[:project])
    @aspect = Discontent::Aspect.create(params[:discontent_aspect])
    @aspect.project = @project
    @post = LifeTape::Post.create(:aspect => @aspect, :status => @aspect.status)
    @post.project = @project
    @aspect.life_tape_posts << @post
    respond_to do |format|
      if @aspect.save and @post.save
        redirect_to "/project/#{@project.id}/life_tape/posts?asp=#{@aspect.id}"
        return
      else
        #format.js {render :action => "new"}
        render "new"
      end
    end
  end
end
