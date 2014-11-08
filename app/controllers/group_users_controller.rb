class GroupUsersController < ApplicationController
  before_action :set_group_user, only: [:show, :edit, :update, :destroy]

  # GET /group_users
  def index
    @group_users = GroupUser.all
  end

  # GET /group_users/1
  def show
  end

  # GET /group_users/new
  def new
    @group_user = GroupUser.new
  end

  # GET /group_users/1/edit
  def edit
  end

  # POST /group_users
  def create
    @group_user = GroupUser.new(group_user_params)

    if @group_user.save
      redirect_to @group_user, notice: 'Group user was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /group_users/1
  def update
    if @group_user.update(group_user_params)
      redirect_to @group_user, notice: 'Group user was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /group_users/1
  def destroy
    @group_user.destroy
    redirect_to group_users_url, notice: 'Group user was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group_user
    @group_user = GroupUser.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def group_user_params
    params.require(:group_user).permit(:group_id, :user_id)
  end
end
