class GroupsController < ApplicationController
  before_action :journal_data
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_filter :check_admin, only: [:new, :edit, :create, :update, :destroy]

  # GET /groups
  def index
    @groups = Group.by_project(@project)
  end

  # GET /groups/1
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  def create
    @group = @project.groups.new group_params

    if @group.save
      redirect_to groups_path(@project)
    else
      render :new
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private
  def check_admin
    redirect_back_or project_path(@project) unless current_user.admin?
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def group_params
    params.require(:group).permit(:name, :description, :project_id)
  end
end
