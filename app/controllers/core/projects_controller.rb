# encoding: utf-8
class Core::ProjectsController < ApplicationController
  # GET /core/projects
  # GET /core/projects.json
  before_filter :boss_authenticate, :only => [:next_stage, :pr_stage]
  before_filter :admin_authenticate, :only => [:new,:edit,:create,:update,:destroy,:list_projects]
  before_filter :project_by_id
  
  def  project_by_id
      unless params[:project].nil?
        @core_project = Core::Project.find(params[:project])
      end
  end

  def index
    @core_projects = Core::Project.order(:id).all
    @core_project = @core_projects.last
    if signed_in?
      @closed_projects = Core::Project.joins("JOIN core_project_users ON core_project_users.project_id = core_projects.id").where("core_project_users.user_id = ?", current_user.id).where(:core_projects => {:type_access => 2}).order("core_projects.id DESC")
    end
    if boss?
      @closed_projects = Core::Project.where(:type_access => 2).order("id DESC")

    end
    @opened_projects = Core::Project.where(:type_access => 0).order("id DESC")
    @demo_projects = Core::Project.where(:type_access => 3).order("id DESC").limit(2)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @core_projects }
    end
  end

  def to_project
    @project = Core::Project.find(params[:project])
    redirect_to  polymorphic_path(@project.redirect_to_current_stage)
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
    @view_projects = Core::Project.where(:type_access => list_type_projects_for_user).order("id DESC")
    @core_project = @view_projects.first
    respond_to do |format|
      format.html { render :layout => 'core/list_projects' }
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
    @core_project.type_project  =  0
    @core_project.status  =  1
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
        format.html { render action: "edit" }
        format.json { render json: @core_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/projects/1
  # DELETE /core/projects/1.json
  def destroy
    @core_project = Core::Project.find(params[:id])
    @core_project.update_attributes(:type_access => 10)

    respond_to do |format|
      format.html { redirect_to core_projects_url }
      format.json { head :no_content }
    end
  end

  def next_stage
    @core_project = Core::Project.find(params[:id])
    @core_project.update_column(:status, @core_project.status + 1)
    redirect_to :back
  end  

  def pr_stage
    @core_project = Core::Project.find(params[:id])
    @core_project.update_column(:status, @core_project.status - 1)
    redirect_to :back
  end


end
