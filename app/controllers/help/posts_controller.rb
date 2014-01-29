class Help::PostsController < ApplicationController
  layout "core/projects"
  before_filter :project_by_id

  def  project_by_id
    unless params[:project].nil?
      @core_project = Core::Project.find(params[:project])
    end
  end

  def index
    @stages = Stage::LIST
    @post = Help::Post.find(1)
  end

  def show

  end


end
