class Core::ProjectsController < ApplicationController
  before_filter :set_core_project
  before_filter :check_access, only: [:prev_stage, :next_stage]

  def show
    @project = ProjectDecorator.new Core::Project.find(params[:id])
    redirect_to polymorphic_path(@project.current_stage_type, project: @project.id)
  end

  # :nocov:
  def index
    @view_projects = Core::Project.where(type_access: list_type_projects_for_user)
    @core_project = @view_projects.first

    respond_to do |format|
      format.html { render layout: 'core/projects' }
    end
  end

  def new
    @project = Core::Project.new
    @core_project = Core::Project.all.last

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @core_project }
    end
  end

  def edit
    @project = Core::Project.find(params[:id])
  end

  def create
    @project = Core::Project.new(core_project_params)

    if @project.save
      @project.project_users.create user_id: current_user.id, owner: true
      redirect_to edit_core_project_path(@project), success: 'Project was successfully created.'
    else
      render action: :new
    end
  end

  def update
    respond_to do |format|
      if @core_project.update_attributes(core_project_params)
        format.html { redirect_to core_projects_path, success: 'Процедура успешно отредактирована' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @core_project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @core_project.update_attributes(type_access: 10)
    respond_to do |format|
      format.html { redirect_to core_projects_url }
      format.json { head :no_content }
    end
  end
  # :nocov:

  def next_stage
    @core_project.go_to_next_stage
    respond_to do |format|
      format.js { render 'update_stage' }
      format.html { redirect_to "/project/#{@core_project.id}" }
    end
  end

  def prev_stage
    @core_project.go_to_prev_stage
    respond_to do |format|
      format.js { render 'update_stage' }
      format.html { redirect_to "/project/#{@core_project.id}" }
    end
  end

  private

  def last_seen_news
    current_user.update_attributes(last_seen_news: Time.zone.now.utc) if current_user && boss?
  end

  def set_core_project
    return false if params[:id].nil?
    @core_project = ProjectDecorator.new Core::Project.find(params[:id])
  end

  def check_access
    return if current_user && @core_project.users.include?(current_user) && current_user.boss?
    redirect_to root_url
  end

  def core_project_params
    params.require(:core_project).permit(:name, :type_access, :short_desc, :desc, :code, :color,
                                         :date_start, :date_end, :count_stages, :project_type_id)
  end

  def filtering_params(params)
    params.slice(:type_content, :type_event, :type_status, :select_users_for_news, :date_begin, :date_end)
  end
end
