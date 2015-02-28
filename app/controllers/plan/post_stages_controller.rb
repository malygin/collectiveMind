class Plan::PostStagesController < ProjectsController
  before_action :set_post

  def new
    @post_stage = Plan::PostStage.new
  end

  def create
    @post_stage = Plan::PostStage.new plan_post_stage_params
    @post_stage.post = @post
    respond_to do |format|
      if @post_stage.save!
        format.js
      else
        format.js { render action: :new }
      end
    end
  end

  def edit
    @post_stage = Plan::PostStage.find(params[:id])
  end

  def update
    @post_stage = Plan::PostStage.find(params[:id])
    @post_stage.update_attributes plan_post_stage_params
    respond_to do |format|
      if @post_stage.save!
        format.js
      else
        format.js { render action: :edit }
      end
    end
  end

  def destroy
    @post_stage = Plan::PostStage.find(params[:id])
    @post_stage.update_column(:status, 1) if current_user?(@post.user) or boss?
  end

  private
  def plan_post_stage_params
    params.require(:plan_post_stage).permit(:name, :desc, :date_begin, :date_end, :status)
  end

  def set_post
    @post = Plan::Post.find(params[:post_id])
  end
end
