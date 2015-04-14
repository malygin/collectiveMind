class Core::Aspect::PostsController < PostsController
  layout 'cabinet', only: [:new]
  before_action :prepare_data, except: [:update, :destroy]
  before_action :set_aspect, except: [:new, :create]

  def voting_model
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
  end

  def update
    @aspect.update_attributes core_aspect_params
  end

  def destroy
    @aspect.destroy if boss?
    redirect_back_or life_tape_posts_path
  end

  private
  def set_aspect
    @aspect = Core::Aspect::Post.find(params[:id])
  end

  def core_aspect_params
    params.require(:core_aspect).permit(:content, :position, :core_aspect_id, :short_desc, :status, :short_name, :color, :detailed_description)
  end

  def prepare_data
    @aspects = Core::Aspect::Post.where(project_id: @project)
  end
end
