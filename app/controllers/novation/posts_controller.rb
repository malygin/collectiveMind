class Novation::PostsController < PostsController
  before_action :set_novation_post, only: [:edit, :update]

  def index
    @posts = @project.novations
  end

  def new
    @novation = current_model.new
  end

  def edit
  end

  def create
    @novation = current_model.new(novation_params)

    if @novation.save
      redirect_to @novation, notice: 'Novation was successfully created.'
    else
      render :new
    end
  end

  def update
    if @novation.update(novation_params)
      redirect_to @novation, notice: 'Novation was successfully updated.'
    else
      render :edit
    end
  end


  private
    def set_novation_post
      @novation = current_model.find(params[:id])
    end

    def novation_params
      params.require(:novation_post).permit(:title, :user_id, :number_views, :status, :project_id, :actions_desc, :actions_ground, :actors, :tools, :impact_group, :impact_env)
    end
end
