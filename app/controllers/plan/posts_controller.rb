# encoding: utf-8

class Plan::PostsController < PostsController

  layout 'life_tape/posts2', :only => [:new, :edit, :show]
  #autocomplete :concept_post, :resource, :class_name => 'Concept::Post' , :full => true

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
    @journals = Journal.events_for_user_feed @project.id
    @my_jounals = Journal.count_events_for_my_feed(@project.id, current_user)
    @mini_help = Help::Post.where(stage:4, mini: true).first

    @news = ExpertNews::Post.first  
    @status = params[:status]
    #@aspects = Discontent::Aspect.where(:project_id => @project)
    @aspects = Discontent::Aspect.where(:project_id => @project, :status => 0)
    add_breadcrumb I18n.t('stages.plan'), plan_posts_path(@project)


  end


  def index
    @posts = current_model.where(:project_id => @project, :status => 0).order('created_at DESC').paginate(:page => params[:page])
    respond_to do |format|
      format.html {render :layout => 'application_two_column'}
      format.json { render json: @posts }
    end
  end

  def new
    #@discontents = Discontent::Post.required_posts(@project)
    @post = current_model.new

    respond_to do |format|
      format.html {render :layout => 'application_two_column'}
    end
  end

  def create
    @project = Core::Project.find(params[:project])
    @plan_post = Plan::Post.new(params[:plan_post])
    @plan_post.number_views =0
    @plan_post.project = @project
    @plan_post.user = current_user
    @plan_post.status = 0


    #unless params[:pa].nil?
    #  params[:pa].each do |pa|
    #    p = Plan::PostAspect.new(pa[1])
    #    p.first_stage= 0
    #    d = Discontent::Post.find(pa[0])
    #    p.discontent = d
    #    @plan_post.post_aspects_other << p
    #  end
    #end
    #
    #unless params[:pa1].nil?
    #  params[:pa1].each do |pa|
    #    p = Plan::PostAspect.new(pa[1])
    #    p.first_stage= 1
    #    d = Discontent::Post.find(pa[0])
    #    p.discontent = d
    #    @plan_post.post_aspects_first << p
    #  end
    #end

    respond_to do |format|
      if @plan_post.save!
        current_user.journals.build(:type_event=>'plan_post_save', :body=>@plan_post.id,   :project => @project).save!
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
    render 'show' , :layout => 'application_two_column'
  end

  def edit
    @post = Plan::Post.find(params[:id])
    #@discontents = Discontent::Post.required_posts(@project)

    add_breadcrumb 'Редактирование записи', polymorphic_path(@post, :project => @project.id)

    render 'edit' , :layout => 'application_two_column'
  end


  def update
    @project = Core::Project.find(params[:project])
    @plan_post = Plan::Post.find(params[:id])
    @plan_post.update_attributes(params[:plan_post])
    @plan_post.post_aspects.destroy_all

    #unless params[:pa].nil?
    #  params[:pa].each do |pa|
    #    p = Plan::PostAspect.new(pa[1])
    #    p.first_stage= 0
    #    d = Discontent::Post.find(pa[0])
    #    p.discontent = d
    #    @plan_post.post_aspects_other << p
    #  end
    #end

    unless params[:pa1].nil?
      params[:pa1].each do |pa|
        p = Plan::PostAspect.new(pa[1])
        p.plan_post = @plan_post
        p.save
        #p.first_stage= 1
        #d = Discontent::Post.find(pa[0])
        #p.discontent = d
        #@plan_post.post_aspects_first << p
        Plan::PostResource.by_post(pa[0]).destroy_all
        unless params[:resor][pa[0]].nil?
          params[:resor][pa[0]].each_with_index do |r,i|
            p.plan_post_resources.build(:name => r, :desc => params[:res][pa[0]][i]).save  if r!=''
          end
        end
      end
    end

    respond_to do |format|
        @plan_post.save
        current_user.journals.build(:type_event=>'plan_post_update', :body=>@plan_post.id,   :project => @project).save!
        format.html { redirect_to plan_post_path(project: @project, id: @plan_post) }
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

def get_cond
  @cond = Concept::PostAspect.find(params[:pa])
  respond_to do |format|
    format.js
  end
  end

def get_cond1
  @cond = Concept::PostAspect.find(params[:pa])
  respond_to do |format|
    format.js
  end
end

def add_first_cond
  @post = Plan::Post.find(params[:id])
  @cond2 = Plan::PostAspect.find(params[:cond_id])
  @cond = Plan::PostFirstCond.new
  @cond.post_aspect = @cond2
  @cond.save

  respond_to do |format|
    format.html # new.html.erb
    format.js
  end
end

 def add_new_discontent
   @discontent = Discontent::Post.new
   @discontent.id = (0..10).map{rand(0..10)}.join
   @aspects = Discontent::Aspect.where(:project_id =>params[:project])
   if params[:plan_stage]
     @div_for_aspects = 'accordion_concept2'
   else
     @div_for_aspects = 'accordion_concept1'
   end
   respond_to do |format|
     format.js
   end

 end

  def get_concepts
    @project = Core::Project.find(params[:project])
    @concepts = Concept::PostAspect.plan_concepts(@project,params[:aspect_id].to_i)
    respond_to do |format|
      format.js
    end
  end

  def add_concept
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @aspects = Discontent::Aspect.where(:project_id => @project, :status => 0)
    @concept_posts = params[:plan_aspect_concepts]
    @first_stage = params[:first_stage]
    @concept_empty = params[:concept_empty]
    @save_form = params[:save_form]
    if @save_form
      @cond_add = []
      if @concept_empty == "1"
        @cond = Plan::PostAspect.create(:plan_post_id => @post.id, :first_stage => @first_stage.to_i, :title => params[:new_post_aspect_title])
        @cond_add << @cond
      else
        unless @concept_posts.nil?
          @concept_posts.each do |cp|
            @concept = Concept::PostAspect.find(cp)
            @cond = Plan::PostAspect.new
            @cond.first_stage = @first_stage.to_i
            @cond.plan_post = @post
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
            @cond.save
            @concept.concept_post.concept_post_resources.each do |rs|
              @cond.plan_post_resources.build(:name => rs.name, :desc => rs.desc).save  if rs!=''
            end
            @cond_add << @cond
          end
        end
      end
    end
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
    @post_stage.destroy if @post_stage.post.user == current_user or boss?
    respond_to do |format|
      format.js
    end
  end

  def new_action
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_action = Plan::PostAction.new
    respond_to do |format|
      format.js
    end
  end

  def edit_action
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_action = Plan::PostAction.find(params[:act_id])
    respond_to do |format|
      format.js
    end
  end

  def create_action
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_stage = Plan::PostStage.find(params[:stage_id])
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_action = Plan::PostAction.new(params[:plan_post_action])
    @post_action.plan_post_aspect = @post_aspect
    @post_action.status = 0
    respond_to do |format|
      if @post_action.save!
        format.js
      else
        format.js { render action: 'new_action' }
      end
    end
  end

  def update_action
    @project = Core::Project.find(params[:project])
    @post = Plan::Post.find(params[:id])
    @post_aspect = Plan::PostAspect.find(params[:con_id])
    @post_action = Plan::PostAction.find(params[:act_id])
    @post_action.update_attributes(params[:plan_post_action])
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
    @post_action.destroy
    respond_to do |format|
      format.js
    end
  end

  def edit_concept

  end

  def destroy_concept

  end
end
