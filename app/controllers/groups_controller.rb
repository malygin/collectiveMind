class GroupsController < ApplicationController
  before_action :journal_data
  before_action :set_group, except: [:index, :new, :create]
  before_filter :check_owner, only: [:edit, :update, :destroy]
  before_filter :only_members, only: :show

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
      @group.group_users.create user_id: current_user.id, owner: true
      redirect_to groups_path(@project)
    else
      render :new
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      redirect_to groups_url(@project, @group)
    else
      render :edit
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
    redirect_to groups_url(@project, @group)
  end

  def become_member
    @group.group_users.new user_id: current_user.id
    @group.save
    redirect_to group_path(@project, @group)
  end

  def leave
    current_user.group_users.where(group_id: @group.id).destroy
    redirect_to groups_path(@project)
  end

  private
  def only_members
    redirect_back_or project_path(@project) unless @group.users.include? current_user
  end

  def check_owner
    redirect_back_or project_path(@project) unless current_user? @group.owner
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find params[:id] || params[:group_id]
  end

  # Only allow a trusted parameter "white list" through.
  def group_params
    params.require(:group).permit(:name, :description, :project_id)
  end
end
