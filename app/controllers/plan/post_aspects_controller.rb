class Plan::PostAspectsController < ProjectsController
  before_action :set_post

  def get_concept
    @post = Plan::Post.find(params[:id])
    @post_concept = Plan::PostAspect.find(params[:con_id])
    @view_post_concept = params[:view_post_concept]
  end

  def update_get_concept
    @post = Plan::Post.find(params[:id])
    @post_concept_save = Plan::PostAspect.find(params[:con_id])
    @post_concept_save.update_attributes(params[:plan_post_aspect])

    create_plan_resources_on_type(@project, @post_concept_save)

    respond_to do |format|
      if @post_concept_save.save
        format.js
      end
    end
  end

  def new
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @aspects = Core::Aspect.where(project_id: @project, status: 0)
    @disposts = Discontent::Post.where(project_id: @project, status: 4)
    @new_ideas = @post.post_aspects.where(plan_post_aspects: {concept_post_id: nil, core_aspect_id: nil})
  end

  def edit
    @post_concept = Plan::PostAspect.find(params[:con_id])
    @post_stage = @post_concept.plan_post_stage
  end

  def update
    @post_concept = Plan::PostAspect.find(params[:concept_id])
    @post_concept.update_attributes plan_post_aspect_params

    create_plan_resources_on_type(@project, @post_concept)

    respond_to do |format|
      if @post_concept.save
        format.js
      else
        format.js { render action: :edit }
      end
    end
  end

  def add_form_for_concept
    @post = Plan::Post.find(params[:post_id])
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

          @cond.duplicate_plan_post_resources(@project, @concept)
        else
          @concept = Concept::Post.find(params[:concept_id])
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
          @cond.core_aspect_id = @concept.core_aspect_id
          @cond.concept_post_aspect = @concept
          @cond.save!

          @cond.duplicate_concept_post_resources(@project, @concept.concept_post)
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
        @post_concept = Concept::Post.find(params[:concept_id])
      end
    end
  end

  def destroy
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @post_concept = Plan::PostAspect.find(params[:con_id])
    @post_actions = @post_concept.plan_post_actions.pluck(:id)
    if current_user?(@post.user) or boss?
      @post_concept.destroy
      @post_concept.plan_post_actions.destroy_all
    end
  end

  private
  def plan_post_aspect_params
    params.require(:plan_post_aspect).permit(:core_aspect_id, :plan_post_id, :positive, :negative, :control, :problems,
                                             :reality, :first_stage, :name, :content, :concept_post_id, :positive_r,
                                             :negative_r, :obstacles, :positive_s, :negative_s, :control_s, :control_r,
                                             :title, :post_stage_id)
  end

  def set_post
    @post = Plan::Post.find(params[:post_id])
  end

  def create_plan_resources_on_type(project, post)
    post.plan_post_resources.by_type(%w(positive_r positive_s negative_r negative_s control_r control_s)).destroy_all
    unless params[:resor].nil?
      params[:resor].each do |r|
        if r[:name]!=''
          resource = post.plan_post_resources.build(name: r[:name], desc: r[:desc], type_res: r[:type_res], project_id: project.id, style: 0)
          unless r[:means].nil?
            r[:means].each do |m|
              if m[:name]!=''
                mean = post.plan_post_resources.build(name: m[:name], desc: m[:desc], type_res: m[:type_res], project_id: project.id, style: 1)
                mean.plan_post_resource = resource
              end
            end
          end
        end
      end
    end
  end
end
