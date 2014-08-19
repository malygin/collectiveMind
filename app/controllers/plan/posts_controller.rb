# encoding: utf-8

class Plan::PostsController < PostsController

  def current_model
    Plan::Post
  end

  def comment_model
    Plan::Comment
  end

  def note_model
    Plan::Note
  end

  def voting_model  
    Plan::Post
  end

  def prepare_data
    @project = Core::Project.find(params[:project]) 

    @status = params[:status]
    @aspects = Discontent::Aspect.where(:project_id => @project, :status => 0)
    add_breadcrumb I18n.t('stages.plan'), plan_posts_path(@project)
    if @project.status == 11
      @vote_all = Plan::Voting.where("plan_votings.plan_post_id IN (#{@project.plan_post.pluck(:id).join(", ")})").uniq_user.count
    end

  end

  def index
    @posts = current_model.where(:project_id => @project, :status => 0).order('created_at DESC').paginate(:page => params[:page])
    post = Plan::Post.where(:project_id => @project, :status => 0).first
    @est_stat = post.estimate_status if post
    respond_to do |format|
      format.html
    end
  end

  def new
    @post = current_model.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @project = Core::Project.find(params[:project])
    @plan_post = Plan::Post.new(params[:plan_post])
    @plan_post.number_views =0
    @plan_post.project = @project
    @plan_post.user = current_user
    @plan_post.status = 0

    respond_to do |format|
      if @plan_post.save!
        current_user.journals.build(:type_event=>'plan_post_save', :body =>trim_content(@plan_post.name),  :first_id=>@plan_post.id,   :project => @project).save!
        format.html { redirect_to   edit_plan_post_path(project: @project, id: @plan_post) }
        format.json { render json: @plan_post, status: :created, location: @plan_post }
        format.js #{head :ok}
      else
        format.html { render action: 'new' }
        format.json { render json: @plan_post.errors, status: :unprocessable_entity }
        format.js #{head :ok}
      end
    end
  end

  def show
    @post = Plan::Post.find(params[:id])
    add_breadcrumb 'Просмотр записи', polymorphic_path(@post, :project => @project.id)
    @comment = comment_model.new
    @comments = @post.comments.paginate(:page => params[:page], :per_page => 30)
    if params[:viewed]
      Journal.events_for_content(@project, current_user, @post.id).update_all("viewed = 'true'")
      @my_journals_count = @my_journals_count - 1
    end
    if current_model.column_names.include? 'number_views'
      if @post.number_views.nil?
        @post.update_column(:number_views, 1)
      else
        @post.update_column(:number_views, @post.number_views+1)
      end
    end
  end

  def edit
    @post = Plan::Post.find(params[:id])
  end


  def update
    @project = Core::Project.find(params[:project])
    @plan_post = Plan::Post.find(params[:id])
    @plan_post.update_attributes(params[:plan_post])

    respond_to do |format|
      @plan_post.save
      current_user.journals.build(:type_event=>'plan_post_update',:body =>trim_content(@plan_post.name), :first_id=>@plan_post.id,   :project => @project).save!
      format.html { redirect_to plan_post_path(project: @project, id: @plan_post) }
      format.js
    end

  end

 def add_aspect
   @id=params[:id]
   @discontent = Discontent::Post.find(@id)
   @concept_id = params[:cond_id]
   unless params[:cond_id].nil?
     @concept = Concept::PostAspect.find(@concept_id)
     @cond = Plan::PostAspect.new
     @cond.name= @concept.name
     @cond.content = @concept.content
     @cond.positive = @concept.positive
     @cond.negative = @concept.negative
     @cond.reality = @concept.reality
     @cond.problems = @concept.problems
     @cond.discontent = @concept.discontent
     @cond.concept_post_aspect = @concept
   else
     @cond = Plan::PostAspect.new
     @cond.discontent = @discontent
     @cond.save
   end

   respond_to do |format|
     format.html # new.html.erb
     format.js
   end
 end


  def add_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @aspects = Discontent::Aspect.where(:project_id => @project, :status => 0)
    @disposts = Discontent::Post.where(:project_id => @project, :status => 4).order(:id)
    @new_ideas = Plan::PostAspect.joins("INNER JOIN plan_posts ON plan_posts.id = plan_post_aspects.plan_post_id").where("plan_posts.project_id = ? and plan_posts.id = ?",@project.id,@post.id).where(:plan_post_aspects => {:concept_post_aspect_id => nil, :discontent_aspect_id => nil})

    respond_to do |format|
      format.js
    end
  end

  def new_stage
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.new
    respond_to do |format|
      format.js
    end
  end

  def edit_stage
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id])
    respond_to do |format|
      format.js
    end
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
    @post_stage.update_column(:status, 1) if current_user?(@post.user)

    respond_to do |format|
      format.js
    end
  end

  def new_action
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id]) unless params[:stage_id].nil?
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_action = Plan::PostAction.new
    @view_concept = params[:view_concept]
    respond_to do |format|
      format.js
    end
  end

  def edit_action
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_stage = Plan::PostStage.find(params[:stage_id]) unless params[:stage_id].nil?
    @post_action = Plan::PostAction.find(params[:act_id])
    respond_to do |format|
      format.js
    end
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
        @post_action.plan_post_action_resources.build(:name => r, :desc => params[:res_action][i], :project_id => @project.id).save  if r!=''
      end
    end
    respond_to do |format|
      format.js
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
        @post_action.plan_post_action_resources.build(:name => r, :desc => params[:res_action][i], :project_id => @project.id).save  if r!=''
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
    @post_action.destroy if current_user?(@post.user)
    respond_to do |format|
      format.js
    end
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
          @concept.plan_post_resources.by_type('positive_r').each do |rs|
            @cond.plan_post_resources.build(:name => rs.name, :desc => rs.desc, :type_res => 'positive_r', :project_id => @project.id).save  if rs!=''
          end
          @concept.plan_post_resources.by_type('negative_r').each do |rs|
            @cond.plan_post_resources.build(:name => rs.name, :desc => rs.desc, :type_res => 'negative_r', :project_id => @project.id).save  if rs!=''
          end
          @concept.plan_post_resources.by_type('control_r').each do |rs|
            @cond.plan_post_resources.build(:name => rs.name, :desc => rs.desc, :type_res => 'control_r', :project_id => @project.id).save  if rs!=''
          end
          @concept.plan_post_means.by_type('positive_s').each do |rs|
            @cond.plan_post_means.build(:name => rs.name, :desc => rs.desc, :type_res => 'positive_s', :project_id => @project.id).save  if rs!=''
          end
          @concept.plan_post_means.by_type('negative_s').each do |rs|
            @cond.plan_post_means.build(:name => rs.name, :desc => rs.desc, :type_res => 'negative_s', :project_id => @project.id).save  if rs!=''
          end
          @concept.plan_post_means.by_type('control_s').each do |rs|
            @cond.plan_post_means.build(:name => rs.name, :desc => rs.desc, :type_res => 'control_s', :project_id => @project.id).save  if rs!=''
          end
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
          @cond.negative_r = @concept.negative_r
          @cond.reality = @concept.reality
          @cond.problems = @concept.problems
          @cond.discontent_aspect_id = @concept.discontent_aspect_id
          @cond.concept_post_aspect = @concept
          @cond.save!
          @concept.concept_post.concept_post_resources.by_type('positive_r').each do |rs|
            @cond.plan_post_resources.build(:name => rs.name, :desc => rs.desc, :type_res => 'positive_r', :project_id => @project.id).save  if rs!=''
          end
          @concept.concept_post.concept_post_resources.by_type('negative_r').each do |rs|
            @cond.plan_post_resources.build(:name => rs.name, :desc => rs.desc, :type_res => 'negative_r', :project_id => @project.id).save  if rs!=''
          end
        end
      else
          @cond = Plan::PostAspect.create(:title => 'Новое нововведение')
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
    respond_to do |format|
      format.js
    end
  end

  def edit_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_concept = Plan::PostAspect.find(params[:con_id])
    @post_stage = @post_concept.plan_post_stage
    respond_to do |format|
      format.js
    end
  end

  def update_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_concept = Plan::PostAspect.find(params[:concept_id])
    @post_concept.update_attributes(params[:plan_post_aspect])

    Plan::PostResource.by_post(@post_concept.id).by_type('positive_r').destroy_all
    unless params[:resor_positive_r].nil?
      params[:resor_positive_r].each_with_index do |r,i|
        @post_concept.plan_post_resources.build(:name => r, :desc => params[:res_positive_r][i], :type_res => 'positive_r', :project_id => @project.id).save  if r!=''
      end
    end
    Plan::PostResource.by_post(@post_concept.id).by_type('negative_r').destroy_all
    unless params[:resor_negative_r].nil?
      params[:resor_negative_r].each_with_index do |r,i|
        @post_concept.plan_post_resources.build(:name => r, :desc => params[:res_negative_r][i], :type_res => 'negative_r', :project_id => @project.id).save  if r!=''
      end
    end
    Plan::PostResource.by_post(@post_concept.id).by_type('control_r').destroy_all
    unless params[:resor_control_r].nil?
      params[:resor_control_r].each_with_index do |r,i|
        @post_concept.plan_post_resources.build(:name => r, :desc => params[:res_control_r][i], :type_res => 'control_r', :project_id => @project.id).save  if r!=''
      end
    end

    Plan::PostMean.by_post(@post_concept.id).by_type('positive_s').destroy_all
    unless params[:resor_positive_s].nil?
      params[:resor_positive_s].each_with_index do |r,i|
        @post_concept.plan_post_means.build(:name => r, :desc => params[:res_positive_s][i], :type_res => 'positive_s', :project_id => @project.id).save  if r!=''
      end
    end
    Plan::PostMean.by_post(@post_concept.id).by_type('negative_s').destroy_all
    unless params[:resor_negative_s].nil?
      params[:resor_negative_s].each_with_index do |r,i|
        @post_concept.plan_post_means.build(:name => r, :desc => params[:res_negative_s][i], :type_res => 'negative_s', :project_id => @project.id).save  if r!=''
      end
    end
    Plan::PostMean.by_post(@post_concept.id).by_type('control_s').destroy_all
    unless params[:resor_control_s].nil?
      params[:resor_control_s].each_with_index do |r,i|
        @post_concept.plan_post_means.build(:name => r, :desc => params[:res_control_s][i], :type_res => 'control_s', :project_id => @project.id).save  if r!=''
      end
    end

    respond_to do |format|
      if @post_concept.save!
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
    if current_user?(@post.user)
      @post_concept.destroy
      @post_concept.plan_post_actions.destroy_all
    end
    respond_to do |format|
      format.js
    end
  end

  def get_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_concept = Plan::PostAspect.find(params[:con_id])
    @view_post_concept = params[:view_post_concept]
    respond_to do |format|
      format.js
    end
  end

  def update_get_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_concept_save = Plan::PostAspect.find(params[:con_id])
    @post_concept_save.update_attributes(params[:plan_post_aspect])
    @post_concept_save.save!
    Plan::PostResource.by_post(@post_concept_save.id).by_type('positive_r').destroy_all
    unless params[:resor_positive_r].nil?
      params[:resor_positive_r].each_with_index do |r,i|
        @post_concept_save.plan_post_resources.build(:name => r, :desc => params[:res_positive_r][i], :type_res => 'positive_r', :project_id => @project.id).save  if r!=''
      end
    end
    Plan::PostResource.by_post(@post_concept_save.id).by_type('negative_r').destroy_all
    unless params[:resor_negative_r].nil?
      params[:resor_negative_r].each_with_index do |r,i|
        @post_concept_save.plan_post_resources.build(:name => r, :desc => params[:res_negative_r][i], :type_res => 'negative_r', :project_id => @project.id).save  if r!=''
      end
    end
    Plan::PostResource.by_post(@post_concept_save.id).by_type('control_r').destroy_all
    unless params[:resor_control_r].nil?
      params[:resor_control_r].each_with_index do |r,i|
        @post_concept_save.plan_post_resources.build(:name => r, :desc => params[:res_control_r][i], :type_res => 'control_r', :project_id => @project.id).save  if r!=''
      end
    end

    Plan::PostMean.by_post(@post_concept_save.id).by_type('positive_s').destroy_all
    unless params[:resor_positive_s].nil?
      params[:resor_positive_s].each_with_index do |r,i|
        @post_concept_save.plan_post_means.build(:name => r, :desc => params[:res_positive_s][i], :type_res => 'positive_s', :project_id => @project.id).save  if r!=''
      end
    end
    Plan::PostMean.by_post(@post_concept_save.id).by_type('negative_s').destroy_all
    unless params[:resor_negative_s].nil?
      params[:resor_negative_s].each_with_index do |r,i|
        @post_concept_save.plan_post_means.build(:name => r, :desc => params[:res_negative_s][i], :type_res => 'negative_s', :project_id => @project.id).save  if r!=''
      end
    end
    Plan::PostMean.by_post(@post_concept_save.id).by_type('control_s').destroy_all
    unless params[:resor_control_s].nil?
      params[:resor_control_s].each_with_index do |r,i|
        @post_concept_save.plan_post_means.build(:name => r, :desc => params[:res_control_s][i], :type_res => 'control_s', :project_id => @project.id).save  if r!=''
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def render_table
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def render_concept_side
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    respond_to do |format|
      format.js
    end
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
    respond_to do |format|
      format.js
    end
  end
  def view_concept_table
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @concept_post = Plan::PostAspect.find(params[:con_id])
    respond_to do |format|
      format.js
    end
  end

  def change_estimate_status
    @project = Core::Project.find(params[:project])
    @est_stat = params[:est_stat]
    posts = Plan::Post.where(:project_id => @project, :status => 0)
    if posts.present? and @est_stat.present?
      posts.each do |est|
        est.update_attributes(:estimate_status => @est_stat)
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def new_note
    #@project = Core::Project.find(params[:project])
    #@post = Plan::Post.find(params[:id])
    #@post_aspect_note = Plan::PostAspect.find(params[:con_id])
    #@type = params[:type_field]
    #@post_note = Plan::Note.new
    super()
    @post_aspect_note = Plan::PostAspect.find(params[:con_id])
  end

  def create_note
    @project = Core::Project.find(params[:project])
    @post = current_model.find(params[:id])
    @type = params[:plan_note][:type_field]
    @post_aspect_note = Plan::PostAspect.find(params[:con_id])
    @post_note = @post_aspect_note.plan_notes.build(params[name_of_note_for_param])
    @post_note.user = current_user

    current_user.journals.build(:type_event=>'my_plan_note', :user_informed => @post.user, :project => @project,  :body=>trim_content(@post_note.content),:body2=> trim_content(@post.name),:first_id => @post.id, :second_id => @post_aspect_note.id,:personal => true,  :viewed=> false).save!

    respond_to do |format|
      if @post_note.save
        format.js
      else
        format.js { render action: "new_note" }
      end
    end
  end


  def destroy_note
    @post_aspect_note = Plan::PostAspect.find(params[:con_id])
    super()
    #@project = Core::Project.find(params[:project])
    #@post = Plan::Post.find(params[:id])
    #@post_aspect_note = Plan::PostAspect.find(params[:con_id])
    #@type = params[:type_field]
    #@post_note = Plan::Note.find(params[:note_id])
    #@post_note.destroy if boss?
  end

end
