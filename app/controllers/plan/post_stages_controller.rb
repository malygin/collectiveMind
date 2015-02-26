class Plan::PostStagesController < ProjectsController
  before_action :set_post

  def new
    @post_stage = Plan::PostStage.new
  end

  def create
    @post_stage = Plan::PostStage.new(params[:plan_post_stage])
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
    @post_stage = Plan::PostStage.find(params[:stage_id])
  end

  def update
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @post_stage.update_attributes(params[:plan_post_stage])
    respond_to do |format|
      if @post_stage.save!
        format.js
      else
        format.js { render action: :edit }
      end
    end
  end

  def destroy
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @post_stage.update_column(:status, 1) if current_user?(@post.user) or boss?
  end

  private
  def plan_post_stage_params
    params.require(:plan_post_stage).permit(:goal, :name, :content)
  end

  def set_post
    @post = Plan::Post.find(params[:id])
  end
end
