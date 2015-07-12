class Plan::PostsController < PostsController
  before_action :set_plan, only: [:edit, :update, :destroy]
  before_action :set_novations, only: [:new, :edit]

  def index
    @posts = @project.plans_for_discussion.created_order
    @project_result = ProjectResulter.new @project unless @project.can_add?(params[:controller])
    @presenter = LastVisitPresenter.new(project: @project, controller: params[:controller], user: current_user)
  end

  def new
    @post = current_model.new
    @post.post_novations.build
  end

  def edit
    @post.post_novations.build if @post.post_novations.empty?
    render action: :new
  end

  def create
    @post = @project.plans.new plan_post_params.merge(user_id: current_user.id)
    @post.post_novations.new plan_post_novation_params
    if @post.valid? && @post.save
      JournalEventSaver.post_save_event(user: current_user, project: @project.project, post: @post)
    end
    @post.update status: current_model::STATUSES[:published]  if params[:plan_post][:published]
    respond_to :js
  end

  def update
    if @post.update_attributes plan_post_params
      JournalEventSaver.post_update_event(user: current_user, project: @project.project, post: @post)
    end
    @post.update(status: current_model::STATUSES[:published])  if params[:plan_post][:published]
    if @post.post_novations.any?
      @post.post_novations.first.update_attributes plan_post_novation_params
    end
    respond_to :js
  end

  def destroy
    @post.destroy if current_user?(@post.user)
    redirect_back_or user_content_plan_posts_path(@project)
  end

  private

  def set_novations
    @novations = @project.novations
  end

  def set_plan
    @post = Plan::Post.find(params[:id])
  end

  def plan_post_params
    params.require(:plan_post).permit(:goal, :name, :content, :tasks_gant)
  end

  def plan_post_novation_params
    params.require(:plan_post_novation).permit(:id, :title, :plan_post_id, :novation_post_id, :project_change, :project_goal,
                                               :project_members, :project_results, :project_time, :members_new, :members_who,
                                               :members_education, :members_motivation, :members_execute, :resource_commands,
                                               :resource_support, :resource_internal, :resource_external, :resource_financial,
                                               :resource_competition, :confidence_commands, :confidence_remove_discontent,
                                               :confidence_negative_results, :members_new_bool, :members_education_bool,
                                               :members_motivation_bool, :resource_commands_bool, :resource_support_bool,
                                               :resource_competition_bool, :confidence_commands_bool,
                                               :confidence_remove_discontent_bool,
                                               :confidence_negative_results_bool)
  end
end
