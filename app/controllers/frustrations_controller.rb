# encoding: utf-8
class FrustrationsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	before_filter :authorized_user, :only => :destroy

	def create
		@frustration = current_user.frustrations.build(params[:frustration])
		if @frustration.save
			flash[:success] = "Неудовлетворенность будет удовлетворена"
			redirect_to root_path
		else
			@frustrations_feed=[]
			render "pages/home"
		end
	end

	def destroy
		@frustration.destroy
		redirect_back_or root_path
	end

	def show
		@frustration = Frustration.find(params[:id])
	end

	private 
		def authorized_user
			@frustration = current_user.frustrations.find_by_id(params[:id])
			redirect_to root_path if @frustration.nil?
		end
end