class GroupTasksController < ApplicationController
  before_action :set_group_task, only: [:edit, :update, :destroy]

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

    if @group_task.save
      redirect_to @group_task, notice: 'Group task was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /group_tasks/1
  def update
    if @group_task.update(group_task_params)
      redirect_to @group_task, notice: 'Group task was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /group_tasks/1
  def destroy
    @group_task.destroy
    redirect_to group_tasks_url, notice: 'Group task was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group_task
    @group_task = GroupTask.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def group_task_params
    params.require(:group_task).permit(:name, :description, :group_id)
  end
end
