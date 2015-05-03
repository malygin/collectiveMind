class Novation::PostsController < PostsController
  include Novation::PostsHelper
  include CloudinaryHelper
  before_action :set_novation_post, only: [:edit, :update, :destroy]
  before_action :set_discontents, only: [:new, :edit]

  def index
    @posts= nil
    @posts = @project.novations.created_order.where(status: [current_model::STATUSES[:published], current_model::STATUSES[:approved]])
    respond_to do |format|

      format.html # show.html.erb
      format.json { render json: @posts.each_with_index.map { |item, index| {id: item.id, index: index+1, title: item.title, content: trim_post_content(item.project_change, 200),
                                                                             user: item.user.to_s, user_avatar: item.user.try(:avatar) ? cl_image_path(item.user.try(:avatar)) : ActionController::Base.helpers.asset_path('no-ava.png'), post_date: Russian::strftime(item.created_at, '%d.%m.%Y'),
                                                                             project_id: item.project_id, sort_date: item.created_at.to_datetime.to_f, sort_comment: item.last_comment.present? ? item.last_comment.created_at.to_datetime.to_f : 0,
                                                                             concept_class: post_concept_classes(item),
                                                                             count_comments: item.comments.count,
                                                                             count_likes: item.users_pro.count,
                                                                             count_dislikes: item.users_against.count,
                                                                             concepts: item.novation_concepts.map { |concept| {id: concept.id, content: trim_post_content(concept.content, 30)} },
                                                                             comments: item.comments.preview.map { |comment| {id: comment.id, date: Russian::strftime(comment.created_at, '%k:%M %d.%m.%y'), user: comment.user.to_s, content: trim_post_content(comment.content, 50)} }} } }

    end
  end

  def new
    @novation = current_model.new
  end

  def edit
    render action: :new
  end

  def create
    @novation = @project.novations.create novation_params.merge(user: current_user)
    @novation.fullness = @novation.update_fullness
    if params[:novation_post][:published]
      @novation.update status: current_model::STATUSES[:published]
    end

    if params[:novation_post_concept]
      params[:novation_post_concept].each do |asp|
        @novation.novation_post_concepts.create(concept_post_id: asp.to_i)
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def update
    @novation.update_attributes novation_params
    @novation.update_fullness
    if params[:novation_post][:published]
      @novation.update status: current_model::STATUSES[:published]
    end

    if params[:novation_post_concept]
      @novation.novation_post_concepts.destroy_all
      params[:novation_post_concept].each do |asp|
        @novation.novation_post_concepts.create(concept_post_id: asp.to_i)
      end
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
    @discontents = Discontent::Post.by_project(@project)
    @concepts = []
    @discontents.each do |discontent|
      @concepts << discontent.dispost_concepts
    end
    @concepts.flatten!.uniq!
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
