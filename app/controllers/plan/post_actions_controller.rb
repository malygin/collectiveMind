class Plan::PostActionsController < ProjectsController
  before_action :set_post

  def new
    @post_stage = Plan::PostStage.find(params[:stage_id]) unless params[:stage_id].nil?
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_action = Plan::PostAction.new
    @view_concept = params[:view_concept]
  end

  def create
    @post_stage = Plan::PostStage.find(params[:stage_id]) unless params[:stage_id].nil?
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @view_concept = params[:view_concept]
    @post_action = Plan::PostAction.new plan_post_action_params
    @post_action.plan_post_aspect = @post_aspect
    @post_action.save!

    unless params[:resor_action].nil?
      params[:resor_action].each_with_index do |r, i|
        @post_action.plan_post_resources.by_type('action_r').build(name: r, desc: params[:res_action][i], project_id: @project.id, style: 3).save if r!=''
      end
    end
  end

  def edit
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_stage = Plan::PostStage.find(params[:stage_id]) unless params[:stage_id].nil?
    @post_action = Plan::PostAction.find(params[:act_id])
  end

  def update
    @post_stage = Plan::PostStage.find(params[:stage_id]) unless params[:stage_id].nil?
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_action = Plan::PostAction.find(params[:act_id])
    @post_action.update_attributes(params[:plan_post_action])
    @post_action.plan_post_resources.by_type('action_r').destroy_all
    unless params[:resor_action].nil?
      params[:resor_action].each_with_index do |r, i|
        @post_action.plan_post_resources.by_type('action_r').build(name: r, desc: params[:res_action][i], project_id: @project.id, style: 3).save if r!=''
      end
    end
    respond_to do |format|
      if @post_action.save!
        format.js
      else
        format.js { render action: :edit }
      end
    end
  end

  def destroy
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_action = Plan::PostAction.find(params[:act_id])
    @post_action.destroy if current_user?(@post.user) or boss?
  end

  private
  def plan_post_action_params
    params.require(:plan_post_action).permit(:goal, :name, :content)
  end

  def set_post
    @post = Plan::Post.find(params[:post_id])
  end
end
