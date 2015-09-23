class Technique::ListProjectsController < ApplicationController
  def create
    params[:technique_list_project][:technique_list_id].each do |tech_id|
      Technique::ListProject.create(technique_list_project_params.merge(technique_list_id: tech_id))
    end
  end

  def update
    @technique_list_project = Technique::ListProject.find(params[:id])
    @technique_list_project.update(technique_list_project_params)
    render :create
  end

  private

  def technique_list_project_params
    params.require(:technique_list_project).permit(:project_id, :technique_list_id)
  end
end
