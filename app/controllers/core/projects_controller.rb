class Core::ProjectsController < ApplicationController
  # GET /core/projects
  # GET /core/projects.json
  #before_filter :boss_authenticate, only: [:next_stage, :pr_stage]
  before_filter :prime_admin_authenticate, only: [:next_stage, :pr_stage, :show, :new, :edit, :create, :update, :destroy, :list_projects]
  before_filter :project_by_id
  before_filter :have_project_access , only: [:news]
  after_filter :last_seen_news , only: [:news]
  layout 'application', only: [:news]

  def project_by_id
    unless params[:project].nil?
      @core_project = Core::Project.find(params[:project])
    end
  end

  def index
    #@core_projects = Core::Project.order(:id).all
    #@core_project = @core_projects.last
    if signed_in?
      if prime_admin?
        @closed_projects = Core::Project.where(type_access: 2).order('id DESC')
      elsif boss?
        @closed_projects = current_user.projects.where(core_projects: {type_access: 2}).order('core_projects.id DESC')
      else
        @closed_projects = current_user.projects.where(core_projects: {type_access: 2}).order('core_projects.id DESC')
      end
      @core_projects = current_user.current_projects_for_user
      @core_project = @core_projects.last
      @club_projects = Core::Project.where(type_access: 1).order('id DESC') if cluber? or boss?
      @opened_projects = Core::Project.where(type_access: 0).order('id DESC')
      @demo_projects = Core::Project.where(type_access: 3).order('id DESC').limit(2)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @core_projects }
    end
  end

  def to_project
    @project = Core::Project.find(params[:project])
    redirect_to polymorphic_path(@project.redirect_to_current_stage)
  end

  # GET /core/projects/1
  # GET /core/projects/1.json
  def show
    @core_project = Core::Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @core_project }
    end
  end

  def list_projects
    @view_projects = Core::Project.where(type_access: list_type_projects_for_user).order('id DESC')
    @core_project = @view_projects.first

    respond_to do |format|
      format.html { render layout: 'core/list_projects' }
    end
  end

  # GET /core/projects/new
  # GET /core/projects/new.json
  def new
    @project = Core::Project.new
    @core_project = Core::Project.all.last

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @core_project }
    end
  end

  # GET /core/projects/1/edit
  def edit
    @project = Core::Project.find(params[:id])
    @core_project = Core::Project.find(params[:id])
  end

  # POST /core/projects
  # POST /core/projects.json
  def create
    @core_project = Core::Project.new(params[:core_project])
    @core_project.type_project = 0
    @core_project.status = 1

    respond_to do |format|
      if @core_project.save
        format.html { redirect_to list_projects_path, success: 'Project was successfully created.' }
        format.json { render json: @core_project, status: :created, location: @core_project }
      else
        format.html { render action: "new" }
        format.json { render json: @core_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /core/projects/1
  # PUT /core/projects/1.json
  def update
    @core_project = Core::Project.find(params[:id])

    respond_to do |format|
      if @core_project.update_attributes(params[:core_project])
        format.html { redirect_to list_projects_path, success: 'Процедура успешно отредактирована' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @core_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/projects/1
  # DELETE /core/projects/1.json
  def destroy
    @core_project = Core::Project.find(params[:id])
    @core_project.update_attributes(type_access: 10)

    respond_to do |format|
      format.html { redirect_to core_projects_url }
      format.json { head :no_content }
    end
  end

  def next_stage
    @core_project = Core::Project.find(params[:id])
    @core_project.update_column(:status, @core_project.status + 1)
    @core_project.set_position_for_aspects if @core_project.status == 3
    redirect_to :back
  end

  def pr_stage
    @core_project = Core::Project.find(params[:id])
    @core_project.update_column(:status, @core_project.status - 1)
    redirect_to :back
  end


  def news
    @project = Core::Project.find(params[:project]) if params[:project]
    @core_project = current_user.current_projects_for_user.last if current_user
    if @project
      events = Journal.events_for_my_feed @project.id, current_user.id
      g = events.group_by { |e| e.first_id }
      @my_journals=g.collect { |k, v| [v.first, v.size] }
      @my_journals_count = @my_journals.size
      @journals_feed = Journal.events_for_user_feed(@project.id).paginate(page: params[:page])
    end

    if @project and params[:asp]
      @aspect = Discontent::Aspect.find(params[:asp])
      @journals_feed_all = Journal.events_for_project(@project.id, events_ignore).paginate(page: params[:page])
    elsif prime_admin?
      @journals_feed_all = Journal.events_for_all_prime(events_ignore).paginate(page: params[:page])
    else
      closed_projects = current_user.projects.where(core_projects: {type_access: 2}).pluck("core_projects.id")
      @journals_feed_all = Journal.events_for_all(list_type_projects_for_user,closed_projects==[] ? [-1] : closed_projects, events_ignore).paginate(page: params[:page])
    end
    @j_count = {today:0, yesterday:0, older:0}
  end

  private
  def last_seen_news
    current_user.update_attributes(last_seen_news: Time.zone.now.utc) if current_user and boss?
  end
end
