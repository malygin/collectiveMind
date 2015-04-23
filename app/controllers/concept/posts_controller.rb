class Concept::PostsController < PostsController
  include Concept::PostsHelper
  before_action :set_concept_post, only: [:edit, :update]
  before_action :set_discontent_posts, only: [:new, :edit]

  def voting_model
    Concept::Post
  end

  def autocomplete
    #@todo для универсализации автокомплита, нужно объединить все ресурсные модели
    field = params[:field]
    answer = Set.new
    answer.merge(Concept::Resource.where(project_id: params[:project]).map { |d| {value: d.name} })
    answer.merge(Concept::PostResource.autocomplete(params[:term]).where(project_id: params[:project], style: (field == 'resor_means_name' ? 1 : 0)).map { |d| {value: d.name} })
    if @project.stage_estimate?
      answer.merge(Plan::PostResource.autocomplete(params[:term]).where(project_id: params[:project], style: (field == 'resor_means_name' ? 1 : 0)).map { |d| {value: d.name} })
    end

    render json: answer.sort_by { |ha| ha[:value].downcase }
  end

  def index
    @posts= nil
    if params[:discontent] and params[:discontent] != '*'
      @posts = Discontent::Post.find(params[:discontent].scan(/\d/).join('')).dispost_concepts
    else
      @posts = @project.concept_ongoing_post
    end
    respond_to do |format|

      format.html # show.html.erb
      format.json { render json: @posts.each_with_index.map { |item, index| {id: item.id, index: index+1, content: trim_post_content(item.content, 100), title: trim_post_content(item.title, 50),
                                                      user: item.user.to_s, user_avatar: ActionController::Base.helpers.asset_path('no-ava.png'), post_date: Russian::strftime(item.created_at, '%d.%m.%Y'),
                                                      project_id: item.project_id, sort_date: item.created_at.to_datetime.to_f, sort_comment: item.last_comment.present? ? item.last_comment.created_at.to_datetime.to_f : 0,
                                                      discontent_class: post_discontent_classes(item),
                                                      count_comments: item.comments.count,
                                                      count_likes: item.users_pro.count,
                                                      count_dislikes: item.users_against.count,
                                                      discontents: item.concept_disposts.map { |dispost| {id: dispost.id, content: dispost.content} },
                                                      comments: item.comments.preview.map { |comment| {id: comment.id, date: Russian::strftime(comment.created_at, '%d.%m.%Y'), user: comment.user.to_s, content: comment.content} }} } }

    end
  end

  def new
    # нововведение без аспекта?
    @asp = Core::Aspect::Post.find(params[:asp]) unless params[:asp].nil?
    @concept_post = current_model.new
    # @resources = Concept::Resource.where(project_id: @project.id)
    # if params[:improve_comment] and params[:improve_stage]
    #   @comment = get_comment_for_stage(params[:improve_stage], params[:improve_comment])
    #   @concept_post.name = @comment.content if @comment
    # end
    # @remove_able = true
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @concept_post = current_model.new concept_post_params.merge(user_id: current_user.id, project_id: @project.id)
    unless params[:concept_post_discontents].nil?
      params[:concept_post_discontents].each do |id, value|
        @concept_post.concept_post_discontents.build(discontent_post_id: id, status: 0)
      end
    end

    #выбор отдельных несовершенств
    # unless params[:check_discontent].nil?
    #   params[:check_discontent].each do |com|
    #     @concept_post.concept_post_discontent_checks.build(discontent_post_id: com[0], status: 1)
    #   end
    # end
    # @concept_post.improve_comment = params[:improve_comment] if params[:improve_comment]
    # @concept_post.improve_stage = params[:improve_stage] if params[:improve_stage]
    # create_concept_resources_on_type(@project, @concept_post)

    respond_to do |format|
      if @concept_post.save
        current_user.journals.build(type_event: 'concept_post_save', body: trim_content(@concept_post.title), first_id: @concept_post.id, project: @project).save!
        format.js
      else
        format.js
      end
    end
  end

  def edit
    @discontent_posts = @discontent_posts - @concept_post.concept_disposts
    render action: :new
  end

  def update
    @concept_post.update_attributes(concept_post_params)
    if @concept_post.valid? and params[:concept_post_discontents].present?
      @concept_post.concept_post_discontents.destroy_all
      params[:concept_post_discontents].each do |cd|
        @concept_post.concept_post_discontents.build(discontent_post_id: cd[0])
      end
    end
    # unless params[:check_discontent].nil?
    #   @concept_post.concept_post_discontent_checks.destroy_all if @concept_post.valid?
    #   params[:check_discontent].each do |com|
    #     @concept_post.concept_post_discontent_checks.build(discontent_post_id: com[0], status: 1)
    #   end
    # end
    # create_concept_resources_on_type(@project, @concept_post)

    respond_to do |format|
      if @concept_post.save
        current_user.journals.build(type_event: 'concept_post_update', body: trim_content(@concept_post.title), first_id: @concept_post.id, project: @project).save!
        format.js
      else
        format.js
      end
    end
  end

  # def next_vote
  #   disposts = Discontent::Post.where(project_id: @project, status: 4).order(:id)
  #   @last_vote = current_user.concept_post_votings.by_project_votings(@project).last
  #
  #   if @last_vote.nil? or params[:id].to_i == @last_vote.concept_post_aspect_id or params[:dis_id].to_i != @last_vote.discontent_post_id
  #     count_create = 1
  #   else
  #     count_create = current_user.concept_post_votings.by_project_votings(@project).where(discontent_post_id: @last_vote.discontent_post_id,
  #                                                                                         concept_post_aspect_id: @last_vote.concept_post_aspect_id).count + 1
  #   end
  #   if current_user.can_vote_for(:concept, @project)
  #     count_create.times do
  #       @last_now = Concept::Voting.create(user_id: current_user.id, concept_post_aspect_id: params[:id], discontent_post_id: params[:dis_id])
  #     end
  #   end
  #   @discontent_post = current_user.able_concept_posts_for_vote(@project, disposts, @last_now)
  #   if @discontent_post.nil?
  #     @post_all = 1
  #     @votes = 0
  #   else
  #     var_for_vote = @discontent_post.concepts_for_vote(@project, current_user, @last_now)
  #     @post_all = var_for_vote[0]
  #     @concept1 = var_for_vote[1]
  #     @concept2 = var_for_vote[2]
  #     @votes = var_for_vote[3]
  #   end
  # end

  def add_dispost
    @dispost = Discontent::Post.find(params[:dispost_id])
    @remove_able = true
  end

  private
  def set_discontent_posts
    @discontent_posts = Discontent::Post.by_project(@project)
  end

  def set_concept_post
    @concept_post = Concept::Post.find(params[:id])
  end

  def prepare_data
    @aspects = Core::Aspect::Post.where(project_id: @project, status: 0)
    @disposts = Discontent::Post.where(project_id: @project, status: 4).order(:id)
    if @project.status == 8
      @vote_all = Concept::Voting.by_posts_vote(@project.discontents.by_status(4).pluck(:id).join(", ")).uniq_user.count
    end
  end

  # def create_concept_resources_on_type(project, post)
  #   unless params[:resor].nil?
  #     params[:resor].each do |r|
  #       if r[:name]!=''
  #         resource = post.concept_post_resources.build(name: r[:name], desc: r[:desc], type_res: r[:type_res], project_id: project.id, style: 0)
  #         unless r[:means].nil?
  #           r[:means].each do |m|
  #             if m[:name]!=''
  #               mean = post.concept_post_resources.build(name: m[:name], desc: m[:desc], type_res: m[:type_res], project_id: project.id, style: 1)
  #               mean.concept_post_resource = resource
  #             end
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

  def concept_post_params
    params.require(:concept_post).permit(:goal, :user_id, :number_views, :status, :content, :censored, :discuss_status,
                                         :useful, :approve_status, :title, :actors, :impact_env)
  end
end
