class Discontent::AspectsController  < ApplicationController
  # GET /discontent/posts
  # GET /discontent/posts.json
  def current_model
    Discontent::Aspect
  end

  def edit
    @aspect = Discontent::Aspect.find(params[:id])
  end

  def update
    @aspect = Discontent::Aspect.find(params[:id])
    @aspect.update_attributes(content: params[:content])
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @aspect = Discontent::Aspect.find(params[:id])
    @aspect.destroy if current_user.boss?
    respond_to do |format|
      format.js
    end
  end

  def new
    @project = Core::Project.find(params[:project])
    @post = Discontent::Aspect.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @project = Core::Project.find(params[:project])
    @aspect = Discontent::Aspect.create(params[:discontent_aspect])
    @aspect.project = @project
    respond_to do |format|
      if @aspect.save
        format.js
      else
        #format.js {render :action => "new"}
        render "new"
      end
    end
  end
end
