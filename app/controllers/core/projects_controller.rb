class Core::ProjectsController < ApplicationController
  # GET /core/projects
  # GET /core/projects.json
  #before_filter :boss_authenticate, only: [:next_stage, :pr_stage]
  before_filter :prime_admin_authenticate, only: [:next_stage, :pr_stage, :show, :new, :edit, :create, :update, :destroy, :list_projects]
  before_filter :project_by_id
  before_action :set_core_project, only: [:show, :edit, :update, :pr_stage, :next_stage, :destroy]
  before_filter :boss_news_authenticate , only: [:news,:users]
  after_filter  :last_seen_news , only: [:news]
  layout 'application', only: [:news,:users]

  # has_scope :by_project
  # has_scope :by_user
  # has_scope :by_note
  # has_scope :by_comment
  # has_scope :by_content
  # has_scope :by_period, :using => [:date_begin, :date_end, :date_all], :type => :hash

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
  end

  # POST /core/projects
  # POST /core/projects.json
  def create
    @core_project = Core::Project.new(core_project_params)
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
    respond_to do |format|
      if @core_project.update_attributes(core_project_params)
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
    @core_project.update_attributes(type_access: 10)

    respond_to do |format|
      format.html { redirect_to core_projects_url }
      format.json { head :no_content }
    end
  end

  def next_stage
    @core_project.update_column(:status, @core_project.status + 1)
    @core_project.set_position_for_aspects if @core_project.status == 3
    redirect_to :back
  end

  def pr_stage
    @core_project.update_column(:status, @core_project.status - 1)
    redirect_to :back
  end

  def news
    @project = Core::Project.find(params[:project]) if params[:project]
    @core_projects = current_user.current_projects_for_journal
    @core_project = @core_projects.first

    if @project
      if @project.project_access(current_user)
        @journals_feed_all = Journal.filter(filtering_params(params)).events_for_project(@project.id).paginate(page: params[:page])
      end
    elsif prime_admin?
      @journals_feed_all = Journal.filter(filtering_params(params)).events_for_all_prime.paginate(page: params[:page])
    else
      closed_projects = current_user.projects.where(core_projects: {type_access: 2}).active_proc.pluck("core_projects.id")
      @journals_feed_all = Journal.filter(filtering_params(params)).events_for_all(list_type_projects_for_user, closed_projects == [] ? [-1] : closed_projects).paginate(page: params[:page])
    end
    @j_count = {today:0, yesterday:0, older:0}
    @users_for_news = User.where("name != ? OR surname != ?", '','').order(:id)
  end

  def users
    @project = Core::Project.find(params[:project]) if params[:project]
    @core_projects = current_user.current_projects_for_user
    @core_project = @core_projects.first
    if @project
      if @project.type_access == 2
        @users = @project.users_in_project.includes(:core_project_scores).where(users: {type_user: [4,5,8,nil]}).order("core_project_scores.score DESC NULLS LAST").paginate(page: params[:page])
      else
        @users = User.joins(:core_project_scores).where("core_project_scores.project_id = ? AND core_project_scores.score > 0", @project.id).where(users: {type_user: [4,5,8,nil]}).order("core_project_scores.score DESC").paginate(page: params[:page])
      end
    else
      @users = User.where(type_user: [4,5,8,nil]).order("score DESC").paginate(page: params[:page])
    end
  end

  private
    def last_seen_news
      current_user.update_attributes(last_seen_news: Time.zone.now.utc) if current_user and boss?
    end

    def set_core_project
      @core_project = Core::Project.find(params[:id])
    end

    def core_project_params
      params.require(:core_project).permit(:name, :type_access, :short_desc, :desc, :type_project, :code, :color, :advices_concept, :advices_discontent)
    end

    def filtering_params(params)
      params.slice(:type_content, :type_event, :type_status, :select_users_for_news, :date_begin, :date_end)
    end
end
