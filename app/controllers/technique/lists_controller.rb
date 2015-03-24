class Technique::ListsController < ApplicationController
  before_action :set_technique_list, only: [:edit, :update]

  def edit
  end

  def update
    if @technique_list.update(technique_list_params)
      redirect_to @technique_list, notice: 'List was successfully updated.'
    else
      render :edit
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_technique_list
    @technique_list = Technique::List.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def technique_list_params
    params.require(:technique_list).permit(:name, :stage, :code)
  end
end
