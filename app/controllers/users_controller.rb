# encoding: utf-8
class UsersController < ApplicationController
	before_filter :authenticate, :only => [:edit, :update]
	before_filter :correct_user, :only => [:edit, :update]

	def new
		@user = User.new
		@title = "Sign up"
	end

	def show 
		@user = User.find(params[:id])
	end

	def edit 
		#@user = User.find(params[:id])
	end

	def index 
		@users = User.all
		puts @users
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success] = "Профиль обновлен"
			redirect_to @user
		else
			render 'edit'
		end
	end

	def create 
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Привет!"
			redirect_to @user
		else
			render 'new'
		end
	end

	private
		def authenticate
			deny_access unless signed_in?
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end


end

