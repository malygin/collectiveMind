class Core::ProjectsController < ApplicationController
  # GET /core/projects
  # GET /core/projects.json
  def index
    @core_projects = Core::Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @core_projects }
    end
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

  # GET /core/projects/new
  # GET /core/projects/new.json
  def new
    @core_project = Core::Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @core_project }
    end
  end

  # GET /core/projects/1/edit
  def edit
    @core_project = Core::Project.find(params[:id])
  end

  # POST /core/projects
  # POST /core/projects.json
  def create
    @core_project = Core::Project.new(params[:core_project])

    respond_to do |format|
      if @core_project.save
        format.html { redirect_to @core_project, notice: 'Project was successfully created.' }
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
        format.html { redirect_to @core_project, notice: 'Project was successfully updated.' }
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
    @core_project.destroy

    respond_to do |format|
      format.html { redirect_to core_projects_url }
      format.json { head :no_content }
    end
  end
end
