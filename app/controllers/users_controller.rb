# encoding: utf-8
class UsersController < ApplicationController
	before_filter :authenticate, :only => [:edit, :update, :show]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user, :only => [:destroy]

	def new
		@user = User.new
		@title = "Sign up"
	end

	def show 
		@user = User.find(params[:id])
		# puts "ahow"
		# @user.test_attempts.each do |a|
		# 	puts a.test_question_attempts
		# 	a.test_question_attempts.each do |q|
		# 		puts q
		# 		puts q.test_question.id
		# 		puts q.answer
		# 	end
		# end
		# if @user.expert?
		# 	@frustrations = Frustration.feed_to_expert.paginate(:page => params[:page])
		# 	@frustration = Frustration.new 

		# 	render 'show_expert'
		# elsif @user.admin?
		# 	@frustration = Frustration.new 
		# 	render 'show_admin'			
 	# 	end
		# @frustrations = @user.frustrations.paginate(:page => params[:page])
		# @frustration = Frustration.new 
		@news = ExpertNews::Post.first

	end

	def edit 
		#@user = User.find(params[:id])
	end

	def index 
		@users = User.order('score DESC').paginate(:page =>params[:page])
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

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "Пользователь удален!!"
		redirect_to users_path
	end

	def forecast
		forecast = params[:forecast]
		fkeys = forecast.keys
		fkeys.each do |f|
			if  forecast[f]==''
				flash[:error] = 'Вы не выбрали все места!'
			end
		end
		if flash[:error].nil?
			for key in forecast.keys 
				frustration = Frustration.find(forecast[key])
				current_user.frustration_forecasts.create(:frustration => frustration, :order => key)
			end
			unless params[:essay]==''
				puts 'save!!'
				current_user.create_frustration_essay(:content => params[:essay])
			end
			flash[:success] = "Вы успешно сделали прогноз, теперь можно голосовать"
		end
		redirect_to :back
	end

	private


		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end




end

