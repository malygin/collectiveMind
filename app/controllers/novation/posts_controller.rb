class Novation::PostsController < PostsController
  before_action :set_novation_post, only: [:edit, :update, :destroy]
  before_action :set_discontents, only: [:new, :edit]
  before_action :user_vote, only: [:index]

  def index
    @posts = nil
    @posts = @project.novations.created_order.where(status: [current_model::STATUSES[:published], current_model::STATUSES[:approved]])
    @presenter = LastVisitPresenter.new(project: @project, controller: params[:controller], user: current_user)
    @project_result = ProjectResulter.new @project unless @project.can_add?(name_controller)
    @last_time_visit = params[:last_time_visit]
    respond_to :html, :json
  end

  def new
    @novation = current_model.new
  end

  def edit
    render action: :new
  end

  def create
    @novation = @project.novations.create novation_params.merge(user: current_user)
    if @novation.save
      JournalEventSaver.post_save_event(user: current_user, project: @project.project, post: @novation)
    end
    @novation.update(status: current_model::STATUSES[:published]) if params[:novation_post][:published]
    if params[:novation_post_concept]
      params[:novation_post_concept].each { |asp| @novation.novation_post_concepts.create(concept_post_id: asp.to_i) }
    end
    respond_to :js
  end

  def update
    @novation.update_attributes novation_params
    if params[:novation_post][:published]
      @novation.update status: current_model::STATUSES[:published]
    end

    return unless params[:novation_post_concept]
    @novation.novation_post_concepts.destroy_all
    params[:novation_post_concept].each do |asp|
      @novation.novation_post_concepts.create(concept_post_id: asp.to_i)
    end
  end

  def destroy
    @novation.destroy if current_user?(@novation.user)
    redirect_back_or user_content_novation_posts_path(@project)
  end

  private

  def set_novation_post
    @novation = current_model.find(params[:id])
  end

  def set_discontents
    # @todo Нужно выбирать все идеи, в том числе и те, которые не привязаны к несовершенствам

    @discontents = @project.discontents
    @concepts = @project.concepts_for_discussion
  end

  def novation_params
    params.require(:novation_post).permit(:title, :status, :content, :approve_status, :project_change, :project_goal,
                                          :project_members, :project_results, :project_time, :members_new, :members_who,
                                          :members_education, :members_motivation, :members_execute, :resource_commands,
                                          :resource_support, :resource_internal, :resource_external, :resource_financial,
                                          :resource_competition, :confidence_commands, :confidence_remove_discontent,
                                          :confidence_negative_results,
                                          :members_new_bool, :members_education_bool, :members_motivation_bool,
                                          :resource_commands_bool, :resource_support_bool, :resource_competition_bool,
                                          :confidence_commands_bool, :confidence_remove_discontent_bool,
                                          :confidence_negative_results_bool)
  end
end
