class GroupTasksController < ApplicationController
  before_action :journal_data
  before_action :set_group_task, except: [:new, :create]

  # GET /group_tasks/new
  def new
    @group_task = GroupTask.new
  end

  # GET /group_tasks/1/edit
  def edit
  end

  # POST /group_tasks
  def create
    @group_task = GroupTask.new(group_task_params)
    @group_task.save
  end

  # PATCH/PUT /group_tasks/1
  def update
    @group_task.update(group_task_params)
  end

  # DELETE /group_tasks/1
  def destroy
    @group_task.destroy
  end

  def assign_user
    @user = User.find(params[:user_id])
    unless @group_task.users.include?(@user)
      current_user.journals.create(type_event: 'my_assigned_task', user_informed: @user, project: @project,
                                   body: "Вам добавили задачу #{@group_task.name} в комнате вашей группы",
                                   first_id: @group_task.group_id, personal: true, viewed: false)
      @group_task.group_task_users.create user_id: @user.id
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group_task
    @group_task = GroupTask.find(params[:id] || params[:group_task_id])
  end

  # Only allow a trusted parameter "white list" through.
  def group_task_params
    params.require(:group_task).permit(:name, :description, :group_id)
  end
end
