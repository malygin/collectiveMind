class Concept::PostsController < PostsController
  before_action :set_concept_post, only: [:edit, :update]

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
    if params[:not_aspect].present?
      @concepts = @project.concepts_without_aspect
    elsif params[:all_aspects].present?
      @concepts = @project.concept_ongoing_post.order('concept_posts.id')
    elsif params[:asp].present?
      @aspect = Core::Aspect.find(params[:asp])
    else
      @aspect = @project.proc_aspects.order('position DESC').first
    end

    if current_user.can_vote_for(:concept, @project)
      disposts = Discontent::Post.where(project_id: @project, status: 4).order(:id)
      last_vote = current_user.concept_post_votings.by_project_votings(@project).last
      @discontent_post = current_user.able_concept_posts_for_vote(@project, disposts, last_vote)
      unless @discontent_post.nil?
        var_for_vote = @discontent_post.concepts_for_vote(@project, current_user, last_vote)
        @post_all = var_for_vote[0]
        @concept1 = var_for_vote[1]
        @concept2 = var_for_vote[2]
        @votes = var_for_vote[3]
      else
        @post_all = 1
        @votes = 0
      end
    end
  end

  def new
    # нововведение без аспекта?
    @asp = Core::Aspect.find(params[:asp]) unless params[:asp].nil?
    @concept_post = current_model.new
    # нововведение без несовершенства?
    @discontent_post = Discontent::Post.find(params[:dis_id]) unless params[:dis_id].nil?
    @resources = Concept::Resource.where(project_id: @project.id)
    if params[:improve_comment] and params[:improve_stage]
      @comment = get_comment_for_stage(params[:improve_stage], params[:improve_comment])
      @concept_post.name = @comment.content if @comment
    end
    @remove_able = true
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @concept_post = current_model.new concept_post_params
    unless params[:cd].nil?
      params[:cd].each do |cd|
        @concept_post.concept_post_discontents.build(discontent_post_id: cd[0], complite: cd[1][:complite], status: 0)
      end
    end
    unless params[:check_discontent].nil?
      params[:check_discontent].each do |com|
        @concept_post.concept_post_discontent_grouped.build(discontent_post_id: com[0], status: 1)
      end
    end

    @concept_post.user = current_user
    @concept_post.project = @project
    @concept_post.improve_comment = params[:improve_comment] if params[:improve_comment]
    @concept_post.improve_stage = params[:improve_stage] if params[:improve_stage]

    create_concept_resources_on_type(@project, @concept_post)

    @concept_post.fullness_apply(@concept_post, params[:resor])

    respond_to do |format|
      if @concept_post.save
        current_user.journals.build(type_event: 'concept_post_save', body: trim_content(@concept_post.title), first_id: @concept_post.id, project: @project).save!
        @aspect_id = params[:asp_id]
        #@todo
        #@discontent_post = @concept_post.discontent
        @remove_able = true
        format.html { redirect_to @aspect_id.nil? ? "/project/#{@project.id}/concept/posts" : "/project/#{@project.id}/concept/posts?asp=#{@aspect_id}" }
        format.js
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  def edit
    # @discontent_post = @concept_post.discontent
    @remove_able = true
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @concept_post.update_status_fields(params[:concept_post])

    unless params[:cd].nil?
      @concept_post.concept_post_discontents.destroy_all if @concept_post.valid?
      params[:cd].each do |cd|
        @concept_post.concept_post_discontents.build(discontent_post_id: cd[0], complite: cd[1][:complite], status: 0)
      end
    end
    unless params[:check_discontent].nil?
      @concept_post.concept_post_discontent_grouped.destroy_all if @concept_post.valid?
      params[:check_discontent].each do |com|
        @concept_post.concept_post_discontent_grouped.build(discontent_post_id: com[0], status: 1)
      end
    end

    create_concept_resources_on_type(@project, @concept_post)

    @concept_post.fullness_apply(@concept_post, params[:resor])

    respond_to do |format|
      if @concept_post.save
        unless params[:fast_update]
          current_user.journals.build(type_event: 'concept_post_update', body: trim_content(@concept_post.title), first_id: @concept_post.id, project: @project).save!
        else
          @discontent_post = @concept_post.discontent
          @remove_able = true
        end
        @aspect_id = @project.proc_aspects.order(:id).first.id
        format.html { redirect_to action: 'show', project: @project, id: @concept_post.id }
        format.js
      else
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  def next_vote
    disposts = Discontent::Post.where(project_id: @project, status: 4).order(:id)
    @last_vote = current_user.concept_post_votings.by_project_votings(@project).last

    if @last_vote.nil? or params[:id].to_i == @last_vote.concept_post_aspect_id or params[:dis_id].to_i != @last_vote.discontent_post_id
      count_create = 1
    else
      count_create = current_user.concept_post_votings.by_project_votings(@project).where(discontent_post_id: @last_vote.discontent_post_id,
                                                                                          concept_post_aspect_id: @last_vote.concept_post_aspect_id).count + 1
    end
    if current_user.can_vote_for(:concept, @project)
      count_create.times do
        @last_now = Concept::Voting.create(user_id: current_user.id, concept_post_aspect_id: params[:id], discontent_post_id: params[:dis_id])
      end
    end
    @discontent_post = current_user.able_concept_posts_for_vote(@project, disposts, @last_now)
    if @discontent_post.nil?
      @post_all = 1
      @votes = 0
    else
      var_for_vote = @discontent_post.concepts_for_vote(@project, current_user, @last_now)
      @post_all = var_for_vote[0]
      @concept1 = var_for_vote[1]
      @concept2 = var_for_vote[2]
      @votes = var_for_vote[3]
    end
  end

  def add_dispost
    @dispost = Discontent::Post.find(params[:dispost_id])
    @remove_able = true
  end

  private
  def set_concept_post
    @concept_post = Concept::Post.find(params[:id])
  end

  def prepare_data
    @aspects = Core::Aspect.where(project_id: @project, status: 0)
    @disposts = Discontent::Post.where(project_id: @project, status: 4).order(:id)
    if @project.status == 8
      @vote_all = Concept::Voting.by_posts_vote(@project.discontents.by_status(4).pluck(:id).join(", ")).uniq_user.count
    end
  end

  def create_concept_resources_on_type(project, post)
    unless params[:resor].nil?
      params[:resor].each do |r|
        if r[:name]!=''
          resource = post.concept_post_resources.build(name: r[:name], desc: r[:desc], type_res: r[:type_res], project_id: project.id, style: 0)
          unless r[:means].nil?
            r[:means].each do |m|
              if m[:name]!=''
                mean = post.concept_post_resources.build(name: m[:name], desc: m[:desc], type_res: m[:type_res], project_id: project.id, style: 1)
                mean.concept_post_resource = resource
              end
            end
          end
        end
      end
    end
  end

  private
  def concept_post_params
    params.require(:concept_post).permit(:goal, :reality, :user_id, :number_views, :life_tape_post_id, :status,
                                         :content, :censored, :status_name, :status_content, :status_positive, :status_positive_r,
                                         :status_negative, :status_negative_r, :status_problems, :status_reality, :improve_comment,
                                         :improve_stage, :discuss_status, :useful, :status_positive_s, :status_negative_s,
                                         :status_control, :status_control_r, :status_control_s, :status_obstacles, :approve_status,
                                         :fullness, :status_all, :core_aspect_id, :positive, :negative, :control, :name, :problems,
                                         :positive_r, :negative_r, :title, :obstacles)
  end
end
