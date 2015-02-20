class Concept::PostsController < PostsController
  before_action :set_concept_post, only: [:edit, :update]
  require 'similar_text'
  require 'set'
  autocomplete :concept_post, :resource, class_name: 'Concept::Post', full: true

  def voting_model
    Concept::PostAspect
  end

  def autocomplete_concept_post_resource
    pr=Set.new
    pr.merge(Concept::Resource.where(project_id: params[:project]).map { |d| {value: d.name} })

    pr.merge(Concept::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?)", "%#{params[:term]}%")
                 .where(project_id: params[:project], style: 0).map { |d| {value: d.value} })

    if @project.status == 9
      pr.merge(Plan::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?)", "%#{params[:term]}%")
                   .where(project_id: params[:project], style: 0).map { |d| {value: d.value} })
    end
    render json: pr.sort_by { |ha| ha[:value].downcase }
  end

  def autocomplete_concept_post_mean
    pr=Set.new
    pr.merge(Concept::Resource.where(project_id: params[:project]).map { |d| {value: d.name} })

    pr.merge(Concept::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?)", "%#{params[:term]}%")
                 .where(project_id: params[:project], style: 1).map { |d| {value: d.value} })

    if @project.status == 9
      pr.merge(Plan::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?)", "%#{params[:term]}%")
                   .where(project_id: params[:project], style: 1).map { |d| {value: d.value} })
    end
    render json: pr.sort_by { |ha| ha[:value].downcase }
  end

  def index
    #@todo сразу все новые выводить, а уже потом он может фильтровать
    if current_user.can_vote_for(:concept, @project)
      redirect_to action: 'vote_list'
    elsif params[:not_aspect].present?
      @concepts = @project.concepts_without_aspect
    elsif params[:all_aspects].present?
      @concepts = @project.concept_ongoing_post.order('concept_posts.id')
    elsif params[:asp].present?
      @aspect = Core::Aspect.find(params[:asp])
    else
      redirect_to "/project/#{@project.id}/concept/posts?asp=#{@project.proc_aspects.order('position DESC').first.id}"
    end
  end

  def new
    @asp = Core::Aspect.find(params[:asp]) unless params[:asp].nil?
    @concept_post = current_model.new
    @discontent_post = Discontent::Post.find(params[:dis_id]) unless params[:dis_id].nil?
    @resources = Concept::Resource.where(project_id: @project.id)
    @pa = Concept::PostAspect.new
    if params[:improve_comment] and params[:improve_stage]
      @comment = get_comment_for_stage(params[:improve_stage], params[:improve_comment])
      @pa.name = @comment.content if @comment
    end
    @remove_able = true
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @concept_post = current_model.new
    @post_aspect = Concept::PostAspect.new(params[:pa])
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

    @concept_post.post_aspects << @post_aspect
    @concept_post.user = current_user
    @concept_post.project = @project
    @concept_post.improve_comment = params[:improve_comment] if params[:improve_comment]
    @concept_post.improve_stage = params[:improve_stage] if params[:improve_stage]

    create_concept_resources_on_type(@project, @concept_post)

    @concept_post.fullness_apply(@post_aspect, params[:resor])

    respond_to do |format|
      if @concept_post.save
        current_user.journals.build(type_event: 'concept_post_save', body: trim_content(@concept_post.post_aspects.first.title), first_id: @concept_post.id, project: @project).save!
        @aspect_id = params[:asp_id]
        @pa = @concept_post.post_aspects.first
        @discontent_post = @pa.discontent
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
    @pa = @concept_post.post_aspects.first
    @discontent_post = @pa.discontent
    @remove_able = true
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @concept_post.update_status_fields(params[:pa])
    @post_aspect = Concept::PostAspect.new(params[:pa])

    @concept_post.post_aspects.destroy_all if @post_aspect.valid?

    unless params[:cd].nil?
      @concept_post.concept_post_discontents.destroy_all if @post_aspect.valid?
      params[:cd].each do |cd|
        @concept_post.concept_post_discontents.build(discontent_post_id: cd[0], complite: cd[1][:complite], status: 0)
      end
    end
    if @post_aspect.valid?
      @concept_post.concept_post_resources.by_type('positive_r').destroy_all
      @concept_post.concept_post_resources.by_type('positive_s').destroy_all
      @concept_post.concept_post_resources.by_type('negative_r').destroy_all
      @concept_post.concept_post_resources.by_type('negative_s').destroy_all
      @concept_post.concept_post_resources.by_type('control_r').destroy_all
      @concept_post.concept_post_resources.by_type('control_s').destroy_all
    end
    unless params[:check_discontent].nil?
      @concept_post.concept_post_discontent_grouped.destroy_all if @post_aspect.valid?
      params[:check_discontent].each do |com|
        @concept_post.concept_post_discontent_grouped.build(discontent_post_id: com[0], status: 1)
      end
    end
    @concept_post.post_aspects << @post_aspect

    create_concept_resources_on_type(@project, @concept_post)

    @concept_post.fullness_apply(@post_aspect, params[:resor])

    respond_to do |format|
      if @concept_post.save
        unless params[:fast_update]
          current_user.journals.build(type_event: 'concept_post_update', body: trim_content(@concept_post.post_aspects.first.title), first_id: @concept_post.id, project: @project).save!
        else
          @pa = @concept_post.post_aspects.first
          @discontent_post = @pa.discontent
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

  def vote_list
    return redirect_to action: "index" unless current_user.can_vote_for(:concept, @project)

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
  def concept_post_params
    params.require(:concept_post).permit(:content, :whend, :whered, :style)
  end

  def set_concept_post
    @concept_post = Concept::Post.find(params[:id])
  end

  def prepare_data
    @aspects = Core::Aspect.where(project_id: @project, status: 0)
    @disposts = Discontent::Post.where(project_id: @project, status: 4).order(:id)
    @vote_all = Concept::Voting.by_posts_vote(@project.discontents.by_status(4).pluck(:id).join(", ")).uniq_user.count if @project.status == 8
  end

  def check_before_update(pa1, pa2)
    pa1 and pa2[:title] and pa2[:name] and pa2[:content] ? true : false
  end

  def create_concept_resources_on_type(project, post)
    unless params[:resor].nil?
      params[:resor].each do |r|
        if r[:name]!=''
          resource = post.concept_post_resources.build(:name => r[:name], :desc => r[:desc], :type_res => r[:type_res], :project_id => project.id, :style => 0)
          unless r[:means].nil?
            r[:means].each do |m|
              if m[:name]!=''
                mean = post.concept_post_resources.build(:name => m[:name], :desc => m[:desc], :type_res => m[:type_res], :project_id => project.id, :style => 1)
                mean.concept_post_resource = resource
              end
            end
          end
        end
      end
    end
  end
end
