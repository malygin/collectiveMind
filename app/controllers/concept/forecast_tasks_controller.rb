# encoding: utf-8
class Concept::ForecastTasksController < ApplicationController
	def create
    @forecast_task = Concept::ForecastTask.new(params[:concept_forecast_task])
    @forecast_task.user = current_user

    respond_to do |format|
      if @forecast_task.save
        #current_user.journals.build(:type_event=>'concept_post_save', :body=>@concept_post.id).save!
        format.html { redirect_to  concept_forecast_path , notice: 'Задача добавлена!' }
        format.json { render json: @concept_post, status: :created, location: @concept_post }
      else
        format.html { render action: "new" }
        format.json { render json: @concept_post.errors, status: :unprocessable_entity }
      end
    end
  end
end
