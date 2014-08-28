class Help::PostsController < PostsController

  before_filter :prepare_data

  def current_model
    Help::Post
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
  end

  def index
    redirect_to help_post_path(@project, id:1)
  end

  def show
    @stages = Core::Project::LIST_STAGES
    @posts = {}
    id = params[:id].to_i
    Help::Post.where(stage: id, mini: false).each {|f| @posts[f.style] = f }
  end
end
