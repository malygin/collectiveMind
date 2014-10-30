# encoding: utf-8

class Plan::PostsController < PostsController

  #autocomplete :concept_post, :resource, :class_name: 'Concept::Post' , :full: true

  def current_model
    Plan::Post
  end

  def comment_model
    Plan::Comment
  end

  def note_model
    Plan::PostNote
  end

  def voting_model  
    Plan::Post
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
    @aspects = Discontent::Aspect.where(project_id: @project, status: 0)
    @vote_all = Plan::Voting.where(plan_votings: {plan_post_id: @project.plan_post.pluck(:id) }).uniq_user.count if @project.status == 11
  end

  def index
    @posts = current_model.where(project_id: @project, status: 0).order('created_at DESC').paginate(page: params[:page])
    post = Plan::Post.where(project_id: @project, status: 0).first
    @est_stat = post.estimate_status if post
  end

  def new
    @post = current_model.new
  end

  def edit
    @post = Plan::Post.find(params[:id])
  end

  def create
    @project = Core::Project.find(params[:project])
    @plan_post = Plan::Post.new(params[:plan_post])
    @plan_post.number_views = 0
    @plan_post.project = @project
    @plan_post.user = current_user
    @plan_post.status = 0
    respond_to do |format|
      if @plan_post.save!
        current_user.journals.build(type_event:'plan_post_save', body:trim_content(@plan_post.name), first_id:@plan_post.id, project: @project).save!
        format.html { redirect_to   edit_plan_post_path(project: @project, id: @plan_post) }
        format.js
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  def update
    @project = Core::Project.find(params[:project])
    @plan_post = Plan::Post.find(params[:id])
    @plan_post.update_attributes(params[:plan_post])
    respond_to do |format|
      if @plan_post.save
        current_user.journals.build(:type_event=>'plan_post_update',:body =>trim_content(@plan_post.name), :first_id=>@plan_post.id,   :project => @project).save!
        format.html { redirect_to plan_post_path(project: @project, id: @plan_post) }
        format.js
      end
    end
  end

  def add_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id])

    @aspects = Discontent::Aspect.where(project_id: @project, status: 0)
    @disposts = Discontent::Post.where(project_id: @project, status: 4).order(:id)
    @new_ideas = Plan::PostAspect.joins("INNER JOIN plan_posts ON plan_posts.id = plan_post_aspects.plan_post_id").where("plan_posts.project_id = ? and plan_posts.id = ?",@project.id,@post.id).where(plan_post_aspects: {concept_post_aspect_id: nil, discontent_aspect_id: nil})
  end

  # @todo methods for stage
  def new_stage
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.new
  end

  def edit_stage
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id])
  end

  def create_stage
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.new(params[:plan_post_stage])
    @post_stage.post = @post
    @post_stage.status = 0
    respond_to do |format|
      if @post_stage.save!
        format.js
      else
        format.js { render action: 'new_stage' }
      end
    end
  end

  def update_stage
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @post_stage.update_attributes(params[:plan_post_stage])
    respond_to do |format|
      if @post_stage.save!
        format.js
      else
        format.js { render action: 'edit_stage' }
      end
    end
  end

  def destroy_stage
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @post_stage.update_column(:status, 1) if current_user?(@post.user) or boss?
  end

  # @todo methods for action
  def new_action
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id]) unless params[:stage_id].nil?
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_action = Plan::PostAction.new
    @view_concept = params[:view_concept]
  end

  def edit_action
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_stage = Plan::PostStage.find(params[:stage_id]) unless params[:stage_id].nil?
    @post_action = Plan::PostAction.find(params[:act_id])
  end

  def create_action
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id]) unless params[:stage_id].nil?
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @view_concept = params[:view_concept]
    @post_action = Plan::PostAction.new(params[:plan_post_action])
    @post_action.plan_post_aspect = @post_aspect
    @post_action.status = 0
    @post_action.save!

    unless params[:resor_action].nil?
      params[:resor_action].each_with_index do |r,i|
        @post_action.plan_post_resources.by_type('action_r').build(:name => r, :desc => params[:res_action][i], :project_id => @project.id, :style => 3).save  if r!=''
      end
    end
  end

  def update_action
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id]) unless params[:stage_id].nil?
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_action = Plan::PostAction.find(params[:act_id])
    @post_action.update_attributes(params[:plan_post_action])
    @post_action.plan_post_action_resources.destroy_all
    unless params[:resor_action].nil?
      params[:resor_action].each_with_index do |r,i|
        @post_action.plan_post_resources.by_type('action_r').build(:name => r, :desc => params[:res_action][i], :project_id => @project.id, :style => 3).save  if r!=''
      end
    end
    respond_to do |format|
      if @post_action.save!
        format.js
      else
        format.js { render action: 'edit_action' }
      end
    end
  end

  def destroy_action
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_action = Plan::PostAction.find(params[:act_id])
    @post_action.destroy if current_user?(@post.user) or boss?
  end

  def add_form_for_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @save_form = params[:save_form]
    if @save_form
      if params[:concept_id]
        if params[:new_idea]
          @concept = Plan::PostAspect.find(params[:concept_id])
          @cond = Plan::PostAspect.new
          @cond.plan_post = @post
          @cond.plan_post_stage = @post_stage
          @cond.title= @concept.title
          @cond.name= @concept.name
          @cond.content = @concept.content
          @cond.positive = @concept.positive
          @cond.negative = @concept.negative
          @cond.control = @concept.control
          @cond.obstacles = @concept.obstacles
          @cond.reality = @concept.reality
          @cond.problems = @concept.problems
          @cond.save!

          @cond.duplicate_plan_post_resources(@project,@concept)
        else
          @concept = Concept::PostAspect.find(params[:concept_id])
          @cond = Plan::PostAspect.new
          @cond.plan_post = @post
          @cond.plan_post_stage = @post_stage
          @cond.title= @concept.title
          @cond.name= @concept.name
          @cond.content = @concept.content
          @cond.positive = @concept.positive
          @cond.negative = @concept.negative
          @cond.obstacles = @concept.obstacles
          @cond.reality = @concept.reality
          @cond.problems = @concept.problems
          @cond.discontent_aspect_id = @concept.discontent_aspect_id
          @cond.concept_post_aspect = @concept
          @cond.save!

          @cond.duplicate_concept_post_resources(@project,@concept.concept_post)
        end
      else
          @cond = Plan::PostAspect.create(title: 'Новое нововведение')
          @cond.plan_post = @post
          @cond.plan_post_stage = @post_stage
          @cond.save!
      end
    else
      if params[:new_concept]
        @post_concept = Plan::PostAspect.new
      else
        @post_concept = Concept::PostAspect.find(params[:concept_id])
      end
    end
  end

  def edit_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_concept = Plan::PostAspect.find(params[:con_id])
    @post_stage = @post_concept.plan_post_stage
  end

  def update_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_concept = Plan::PostAspect.find(params[:concept_id])
    @post_concept.update_attributes(params[:plan_post_aspect])

    create_plan_resources_on_type(@project, @post_concept, 'positive_r', 'positive_s')
    create_plan_resources_on_type(@project, @post_concept, 'negative_r', 'negative_s')
    create_plan_resources_on_type(@project, @post_concept, 'control_r', 'control_s')

    respond_to do |format|
      if @post_concept.save
        format.js
      else
        format.js { render action: 'edit_concept' }
      end
    end
  end

  def destroy_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @post_concept = Plan::PostAspect.find(params[:con_id])
    @post_actions = @post_concept.plan_post_actions.pluck(:id)
    if current_user?(@post.user) or boss?
      @post_concept.destroy
      @post_concept.plan_post_actions.destroy_all
    end
  end

  def get_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_concept = Plan::PostAspect.find(params[:con_id])
    @view_post_concept = params[:view_post_concept]
  end

  def update_get_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_concept_save = Plan::PostAspect.find(params[:con_id])
    @post_concept_save.update_attributes(params[:plan_post_aspect])

    create_plan_resources_on_type(@project, @post_concept_save, 'positive_r', 'positive_s')
    create_plan_resources_on_type(@project, @post_concept_save, 'negative_r', 'negative_s')
    create_plan_resources_on_type(@project, @post_concept_save, 'control_r', 'control_s')

    respond_to do |format|
      if @post_concept_save.save
        format.js
      end
    end
  end

  def render_table
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @render_type = params[:render_type]
  end

  def render_concept_side
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
  end

  def view_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    if params[:new_idea]
      @concept_post = Plan::PostAspect.find(params[:con_id])
    elsif params[:what_view]
      @dispost = Discontent::Post.find(params[:post_id])
      @post_stage = Plan::PostStage.find(params[:stage_id])
    else
      @dispost = Discontent::Post.find(params[:post_id])
      @concept_post = Concept::PostAspect.find(params[:con_id])
    end
  end

  def view_concept_table
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @concept_post = Plan::PostAspect.find(params[:con_id])
  end

  def change_estimate_status
    @project = Core::Project.find(params[:project])
    @est_stat = params[:est_stat]
    posts = Plan::Post.where(project_id: @project, status: 0)
    if posts.present? and @est_stat.present?
      posts.each do |est|
        est.update_attributes(estimate_status: @est_stat)
      end
    end
  end

  # @todo methods for note
  def new_note
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_aspect_note = Plan::PostAspect.find(params[:con_id])
    @type = params[:type_field]
    @post_note = Plan::Note.new
  end

  def create_note
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_aspect_note = Plan::PostAspect.find(params[:con_id])
    @post_note = Plan::Note.create(params[:plan_note])
    @post_note.post_id = @post_aspect_note.id
    @post_note.type_field = params[:type_field]
    @post_note.user = current_user
    @type = params[:type_field]
    current_user.journals.build(type_event:'my_plan_note', user_informed: @post.user, project: @project,  body:trim_content(@post_note.content),body2: trim_content(@post.name),first_id: @post.id, second_id: @post_aspect_note.id,personal: true,  viewed: false).save!

    respond_to do |format|
      if @post_note.save
        format.js
      else
        render "new_note"
      end
    end
  end

  def destroy_note
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_aspect_note = Plan::PostAspect.find(params[:con_id])
    @type = params[:type_field]
    @post_note = Plan::Note.find(params[:note_id])
    @post_note.destroy if boss?
  end

  private
    def create_plan_resources_on_type(project, post, type_r, type_s)
      post.plan_post_resources.by_type(type_r).destroy_all
      post.plan_post_resources.by_type(type_s).destroy_all
      unless params[('resor_'+type_r).to_sym].nil?
        params[('resor_'+type_r).to_sym].each_with_index do |r,i|
          if r[1][0]!=''
            resource = post.plan_post_resources.build(:name => r[1][0], :desc => params[('resor_'+type_r).to_sym] ? params[('resor_'+type_r).to_sym]["#{r[0]}"][0] : '', :type_res => type_r, :project_id => project.id, :style => 0)
            if params[('resor_'+type_s).to_sym] and params[('resor_'+type_s).to_sym]["#{r[0]}"]
              params[('resor_'+type_s).to_sym]["#{r[0]}"].each_with_index do |m,ii|
                if m!=''
                  mean = post.plan_post_resources.build(:name => m, :desc => params[('resor_'+type_s).to_sym] ? params[('resor_'+type_s).to_sym]["#{r[0]}"][ii] : '',:type_res => type_s, :project_id => project.id, :style => 1)
                  mean.plan_post_resource = resource
                end
              end
            end
          end
        end
      end
    end
end
