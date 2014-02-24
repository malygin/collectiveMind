# encoding: utf-8
class UsersController < ApplicationController
	layout 'application_two_column'
	#before_filter :authenticate, :only => [:edit, :update, :show]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user, :only => [:destroy]

	def new
		@user = User.new
		@title = "Sign up"
	end

	def show

    @user = User.find(params[:id])
    @project = Core::Project.find(params[:project])

    add_breadcrumb  @user.name_title, user_path(@project, @user)

    @journals = Journal.events_for_user_show @project.id, @user.id, 30

  end

	def edit
    @project = Core::Project.find(params[:project])

    @user = User.find(params[:id])
    add_breadcrumb  "Редактирование профиля: #{@user.name_title}", edit_user_path(@project, @user)

  end

	def index
    @project = Core::Project.find(params[:project])

    @users = User.where('score>0').order('score DESC').paginate(:page =>params[:page])
    #@users1 = User.where('score_g>0').order('score_g DESC').paginate(:page =>params[:page])
    #@users2 = User.where('score_a>0').order('score_a DESC').paginate(:page =>params[:page])
    #@users3 = User.where('score_o>0').order('score_o DESC').paginate(:page =>params[:page])
	end

	def update
    @project = Core::Project.find(params[:project])

    @user = User.find(params[:id])

    params[:user].delete(:password) if params[:user][:password].blank?
		if @user.update_attributes(params[:user])
			flash[:success] = "Профиль обновлен"
			redirect_to user_path(@project,@user)
		else
			render 'edit'
		end
	end

	def create 
		#@user = User.new(params[:user])
		#cp = nil
		#Core::Project.all.each do |pr|
     # puts 'aaa'
		#	if @user.secret == pr.secret
		#		@user.projects << pr
		#	end
		#end
    #
		#if @user.secret!='' and !@user.projects.empty? and @user.save
		#	sign_in @user
		#	flash[:success] = "Добро пожаловать!"
		#	redirect_to root_path
		#else
		#	if   @user.secret=='' or @user.projects.empty?
		#		flash[:error] = "Кодовое слово введено неверно!"
		#	end
		#	render 'new'
		#end
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
				current_user.create_frustration_essay(:content => params[:essay])
			end
			flash[:success] = "Вы успешно сделали прогноз, теперь можно голосовать"
		end
		redirect_to :back
	end

	def forecast_concept
		forecast = params[:forecast]
		fkeys = forecast.keys
		fkeys.each do |f|
			if  forecast[f]==''
				flash[:error] = 'Вы не выбрали все места!'
			end
		end
		if flash[:error].nil?
			for key in forecast.keys 
				task = Concept::ForecastTask.find(forecast[key])
				current_user.concept_forecasts.create(:forecast_task => task, :position => key)
			end
			unless params[:essay]==''				
				current_user.create_concept_essay(:content => params[:essay])
			end
			flash[:success] = "Вы успешно сделали прогноз, теперь можно голосовать"
		end
		redirect_to :back
	end

	def forecast_plan
		if params[:forecast_student]=='' or params[:forecast_jury]==''
			flash[:error] = 'Вы не выбрали проекты для каждой категории!'
		else
			plan_student = Plan::Post.find(params[:forecast_student])
			plan_jury = Plan::Post.find(params[:forecast_jury])
			current_user.plan_forecasts.create(:best_jury_post => plan_jury, :best_student_post => plan_student)
			flash[:success] = "Вы успешно сделали прогноз, теперь можно голосовать"
		end		
		redirect_to :back
	end

	def add_score
		user = User.find(params[:id])
		if boss?
			user.update_column(:score, user.score + params[:score].to_i)
      user.update_column(:score_a, user.score_a + params[:score].to_i)

      @project = Core::Project.find(params[:project])
      user.journals.build(:type_event=>'add_score', :project => @project, :body=>params[:score]).save
    end
		render json: user.score
  end

	def add_score_essay
		user = User.find(params[:id])
		if boss?
      user.add_score(params[:score].to_i,:score_a)
      @project = Core::Project.find(params[:project])
      user.journals.build(:type_event=>'add_score_essay', :project => @project, :body=>params[:score]).save
    end
		render json: user.score
	end

	private


		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end




end

