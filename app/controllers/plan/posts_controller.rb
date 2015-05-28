class Plan::PostsController < PostsController
  include MarkupHelper
  before_action :set_plan, only: [:edit, :update, :destroy]
  before_action :set_novations, only: [:new, :edit]
  #autocomplete :concept_post, :resource, :class_name: 'Concept::Post' , :full: true

  def voting_model
    Plan::Post
  end

  def prepare_data
    @aspects = Core::Aspect::Post.where(project_id: @project, status: 0)
    @vote_all = Plan::Voting.where(plan_votings: {plan_post_id: @project.plan_post.pluck(:id)}).uniq_user.count if @project.status == 11
  end

  def index
    @posts = @project.plan_post.where(status: 1).created_order
    # @posts = current_model.where(project_id: @project, status: 0).order('created_at DESC')
    # post = Plan::Post.where(project_id: @project, status: 0).first
    # @est_stat = post.estimate_status if post
    # @comment = comment_model.new
  end

  def new
    @post = current_model.new
    @post.post_novations.build
  end

  def edit
    if @post.post_novations.empty?
      @post.post_novations.build
    end
    render action: :new
  end

  def create
    @post = @project.plan_post.new plan_post_params.merge(user_id: current_user.id)
    @post.post_novations.new plan_post_novation_params
    if @post.valid? and  @post.save
      current_user.journals.create!(type_event: 'plan_post_save', body: trim_content(@post.name), first_id: @post.id, project: @project)
    end

    @post.update status: current_model::STATUSES[:published]  if params[:plan_post][:published]

    respond_to do |format|
      format.js
    end
  end

  def update
    if @post.update_attributes plan_post_params
      current_user.journals.build(type_event: 'plan_post_update', body: trim_content(@post.name), first_id: @post.id, project: @project).save!
    end
    if params[:plan_post][:published]
      @post.update status: current_model::STATUSES[:published]
    end
    if @post.post_novations.any?
      @post.post_novations.first.update_attributes plan_post_novation_params
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @post.destroy if current_user?(@post.user)
    redirect_back_or user_content_plan_posts_path(@project)
  end

  def vote
     @post_vote = voting_model.find(params[:id])
     @post_vote.final_votings.where(user_id: current_user, type_vote: params[:type_vote].to_i).destroy_all
     @post_vote.final_votings.create(user: current_user, type_vote: params[:type_vote], status: params[:status]).save!

  end

  # # @todo methods for note
  # def new_note
  #   super()
  #   @post_aspect_note = Plan::PostAspect.find(params[:con_id])
  # end
  #
  # def create_note
  #   @post = current_model.find(params[:id])
  #   @type = params[:plan_note][:type_field]
  #   @post_aspect_note = Plan::PostAspect.find(params[:con_id])
  #   @post_note = @post_aspect_note.plan_notes.build(params[name_of_note_for_param])
  #   @post_note.user = current_user
  #
  #   current_user.journals.build(type_event: 'my_plan_note', user_informed: @post.user, project: @project, body: trim_content(@post_note.content), body2: trim_content(@post.name), first_id: @post.id, second_id: @post_aspect_note.id, personal: true, viewed: false).save!
  #
  #   respond_to do |format|
  #     if @post_note.save
  #       format.js
  #     else
  #       format.js { render action: "new_note" }
  #     end
  #   end
  # end
  #
  # def destroy_note
  #   @post_aspect_note = Plan::PostAspect.find(params[:con_id])
  #   super()
  # end

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
