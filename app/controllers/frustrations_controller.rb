# encoding: utf-8
class FrustrationsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]

	def create
		@frustration = current_user.frustrations.build(params[:frustration])
		if @frustration.save
			flash[:success] = "Неудовлетворенность будет удовлетворена"
			redirect_to root_path
		else
			render "pages/home"
		end
	end

	def destroy
	end
end