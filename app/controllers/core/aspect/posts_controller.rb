class Core::Aspect::PostsController < PostsController
  before_action :prepare_data, except: [:update, :destroy]
  before_action :set_aspect, only: [:edit, :update, :destroy]

  def voting_model
    Core::Aspect::Post
  end

  def current_model
    Core::Aspect::Post
  end

  def new
    @aspect = Core::Aspect::Post.new
  end

  def create
    @aspect = @project.aspects.create core_aspect_params.merge(user: current_user)
    respond_to do |format|
      format.js
    end
  end

  def edit
    render action: :new
  end

  def update
    @aspect.update_attributes core_aspect_params
  end

  def destroy
    @aspect.destroy if current_user?(@aspect.user)
    redirect_back_or user_content_collect_info_posts_path(@project)
  end

  private
  def set_aspect
    @aspect = Core::Aspect::Post.find(params[:id])
  end

  def core_aspect_params
    params.require(:core_aspect_post).permit(:content, :position, :core_aspect_id, :short_desc, :status, :short_name, :color, :detailed_description)
  end

  def prepare_data
    @aspects = Core::Aspect::Post.where(project_id: @project)
  end
end
