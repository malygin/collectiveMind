# encoding: utf-8
class UsersController < ApplicationController
	layout 'application_two_column'
	#before_filter :authenticate, :only => [:edit, :update, :show]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user, :only => [:destroy]
  before_filter :journal_data, :only => [:index, :new, :edit, :show, :users_rc]
	def new
		@user = User.new
		@title = "Sign up"
	end

	def show

    @user = User.find(params[:id])
    @project = Core::Project.find(params[:project])

    add_breadcrumb  @user, user_path(@project, @user)

    if @user != current_user
     @journals = Journal.events_for_user_show @project.id, @user.id, 30
    else
      @journals = Journal.events_for_my_feed @project.id, @user.id, 30
    end
    if @my_journals_count > 0
      @journals.update_all(viewed: true)
    end

  end

	def edit

    @user = User.find(params[:id])
    add_breadcrumb  "Редактирование профиля: #{@user}", edit_user_path(@project, @user)

  end

	def index
    @project = Core::Project.find(params[:project])
    add_breadcrumb I18n.t('menu.raiting'), users_path(@project)
       #@users = User.where('score>0').where('admin=?', false).order('score DESC').paginate(:page =>params[:page])
    @users = User.joins(:core_project_scores).where("core_project_scores.project_id = ? AND core_project_scores.score > 0", @project.id).where(:users => {:type_user => [4,7]}).order("core_project_scores.score DESC").paginate(:page =>params[:page])
  end

  def show_top
    @project = Core::Project.find(params[:project])
    #@users = User.scope_score_name(params[:score_name]).where('admin=?', false).paginate(:page =>params[:page])
    @users = User.joins(:core_project_scores).where("core_project_scores.project_id = ? AND core_project_scores.score > 0", @project.id).where(:users => {:type_user => [4,7]}).order("core_project_scores.#{params[:score_name]} DESC").paginate(:page =>params[:page])
    @score_name = params[:score_name]
    respond_to do |format|
      format.js
    end
  end

  def users_rc
    @project = Core::Project.find(params[:project])

    @users = User.where(:type_user => [4,7]).order('score DESC').paginate(:page =>params[:page])
    #@users = User.where('admin=?', false).where('type_user = 4 or type_user = 5').order('score DESC').paginate(:page =>params[:page])
  end

  def update_score
    @project = Core::Project.find(params[:project])
    @user = User.find(params[:id])
    params[:value] = "0" if params[:value] == ""
    respond_to do |format|
      if @user.update_attributes(params[:name] => params[:value])
        format.json { head :no_content } # 204 No Content
        format.js { head :no_content }
      end
    end
  end

  def club_toggle
    @project = Core::Project.find(params[:project])
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes!(:type_user => view_context.club_toggle_user(@user))
        format.js
      end
    end
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
      @project = Core::Project.find(params[:project])
      user.add_score_by_type(@project, params[:score].to_i, :score_a)

      user.journals.build(:type_event=>'add_score', :project => @project, :body=>params[:score]).save
      current_user.journals.build(:type_event=>'my_add_score', :user_informed => user, :project => @project, :body=>params[:score], :viewed=> false).save!

    end
    respond_to do |format|

      format.js
    end
  end

	def add_score_essay
		user = User.find(params[:id])
		if boss?
      # user.add_score(params[:score].to_i,:score_a)
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

