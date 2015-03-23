class Technique::ListProjectsController < ApplicationController
  before_action :set_technique_list_project, only: [:edit, :update, :destroy]

  def new
    @technique_list_project = Technique::ListProject.new
  end

  def edit
  end

  def create
    @technique_list_project = Technique::ListProject.new(technique_list_project_params)

    if @technique_list_project.save
      redirect_to @technique_list_project, notice: 'List project was successfully created.'
    else
      render :new
    end
  end

  def update
    if @technique_list_project.update(technique_list_project_params)
      redirect_to @technique_list_project, notice: 'List project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @technique_list_project.destroy
    redirect_to technique_list_projects_url, notice: 'List project was successfully destroyed.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_technique_list_project
    @technique_list_project = Technique::ListProject.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def technique_list_project_params
    params.require(:technique_list_project).permit(:core_project_id, :technique_list_id)
  end
end
