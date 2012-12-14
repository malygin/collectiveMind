# encoding: utf-8
class FrustrationsController < ApplicationController
	before_filter :authenticate, :only => [:create, :destroy]
	before_filter :authorized_user, :only => :destroy
	#todo method only for expert

	def create
		fr = params[:frustration]
		if fr[:content_text].nil? and fr[:what].nil? and  fr[:when].nil? and fr[:wherein].nil?
			flash[:error] = "Поля не заполнены"
			redirect_to current_user
		else
			@frustration = current_user.frustrations.build(params[:frustration])
			unless fr[:what].nil? and  fr[:when].nil? and fr[:wherein].nil?
				#create structirung fr
				@frustration.status = 2
				@frustration.structuring_date = Time.now
			end
			if current_user.admin?
				@frustration.status = 4
			end
			
			if current_user.expert?
				@frustration.status = 6 
			end

			if @frustration.save
				flash[:success] = "Недовольство добавлено в список!"
				redirect_to current_user
			else
				@frustrations_feed=[]
				render "pages/home"
			end
		end
	end
	
	def show_forecast
		@frustrations = Frustration.feed_voted.sort{|x, y| y.voiting_score <=> x.voiting_score}[0..2]
		fr_with_orders = {@frustration[0] => '1', @frustration[1] => '2', @frustration [2] => '3'}

		forecasts = FrustrationForecast.find(:all, :order => "user_id")
		@fres={}
		forecasts.each do |f|
			if @fres[f.user].nil?
				dic = {}
				score = 0
				dic[f.frustration] = f.order
				if f.frustration in fr_with_orders.keys
					score +=5
				end
				if fr_with_orders[f.frustration] == f.order
					score += 5
				end	
				@fres[f.user]=[score, dic]
			else
				if f.frustration in fr_with_orders.keys
					@fres[f.user][0] += 5
				end
				if fr_with_orders[f.frustration] == f.order
					@fres[f.user][0] += 5
				end	
				@fres[f.user][1][f.frustration] = f.order
			end
		end
	end

	def destroy
		@frustration.destroy
		redirect_back_or root_path
	end

#todo check author of comment - true?

	def archive
		if not params[:author_comment].nil?
			@user = User.where(:id => (params[:author_comment])).first
			new_score = @user.score+Settings.scores.unstructure.denial_for_negative_comment
			@user.update_column(:score, new_score)
		end
		@frustration = Frustration.find(params[:id])
		@frustration.update_attribute(:status,1) 
		@frustration.update_attribute(:negative_user, @user)
		flash[:success] = "Отправлена в архив!"
		redirect_to root_path
	end

	def to_expert
		@frustration = Frustration.find(params[:id])
		@frustration.update_column(:status, 3)
		flash[:success] = "Отправлена эксперту"
		redirect_to root_path
	end

	def expert_accept
		@frustration = Frustration.find(params[:id])
		@frustration.update_column(:status, 4)
		update_scores_for_comments(Settings.scores.expert.allow, Settings.scores.expert) 
		flash[:success] = "Недовольство принято"
		redirect_to user_path(current_user)
	end


	def update_scores_for_comments( score_max, scores)
		unless @frustration.struct_user.nil?
			@frustration.struct_user.update_column(:score, @frustration.struct_user.score + score_max*scores.ratio_for_structuring_comment)
			score_max = score_max - score_max * scores.ratio_for_structuring_comment
		end
		unless @frustration.frustration_useful_comments.nil? or @frustration.frustration_useful_comments.empty?
			length = @frustration.frustration_useful_comments.length
			for comment in @frustration.frustration_useful_comments
				comment.user.update_column(:score, comment.user.score + (score_max*scores.ratio_for_negative_comment)/length)
			end
			score_max = score_max - score_max * scores.ratio_for_negative_comment
		end
		puts score_max
		@frustration.user.update_column(:score, @frustration.user.score + score_max)
	end


	def expert_accept_with_replacement
		# remove existing frustrations
		@frustration_for_remove = Frustration.find(params[:accepted_frustrations])
		@frustration_for_remove.update_column(:status, 5)
		# add scores and move frustration to accepted
		@frustration = Frustration.find(params[:id])
		@frustration.update_column(:status, 4)
		update_scores_for_comments(Settings.scores.expert.allow_with_replacement, Settings.scores.expert )
		flash[:success] = "Недовольство принято"
		redirect_to user_path(current_user)
	end

	def expert_decline()
		penalty =  to_bool(params[:penalty])
		# puts penalty
		@frustration = Frustration.find(params[:id])
		@frustration.update_column(:status, 5)
		#if we have negative comments - ban 
		if  not @frustration.comments_after_structuring.empty? and penalty
			@frustration.user.update_column(:score, @frustration.user.score + Settings.scores.expert.deny_with_negative)
		end
		flash[:success] = "Недовольство отклонено"
		redirect_to user_path(current_user)
	end

	def edit_to_struct
		@frustration = Frustration.find(params[:id])
		@author_comment = params[:author_comment]
	end

	def edit_to_expert
		@frustration = Frustration.find(params[:id])
		@author_comment = params[:author_comment]
	end

	def to_archive_by_admin
		@frustration = Frustration.find(params[:id])
		#puts params
		@frustration.update_attributes(:status => 1, :trash => true)
		if to_bool(params[:del])
			@frustration.user.update_column(:score, @frustration.user.score + Settings.scores.unstructure.violation_frustration) 
		end
		flash[:success] = "Отправлено в архив"
		redirect_to root_path
	end

	def update_to_struct
		@frustration = Frustration.find(params[:id])
		@user = User.where(:id => (params[:author_comment])).first

		if @frustration.update_attributes(:what_old => @frustration.what,
			:wherin_old => @frustration.wherin,
			:when_old => @frustration.when,
			:content_text_old => @frustration.content_text,
			:struct_user => @user, 
			:what => params[:frustration][:what],
			:wherin => params[:frustration][:wherin],
			:when => params[:frustration][:when],
			:structuring_date => Time.now, :status => 2 )
			flash[:success] = "Недовольство  оформлено"
			redirect_to '/structure'
		else 
			flash[:error] = "Ошибка сохранения недовольства, следите за размером вашего недовольства!"
			redirect_to :action => :edit_to_struct, :id => @frustration.id
		end

	end	

	def update_to_expert
		@frustration = Frustration.find(params[:id])
		unless params[:comment].nil?
			for comment_id in params[:comment].keys
				useful_comment = FrustrationComment.find(comment_id)
				useful_comment.useful_frustration_id = @frustration.id
				useful_comment.save
			end
		end
		@frustration.update_attributes(
			:what_expert => params[:frustration][:what],
			:wherin_expert => params[:frustration][:wherin],
			:when_expert => params[:frustration][:when], :status => 3 )
		flash[:success] = "Недовольство  отправлено эксперту"
		redirect_to '/accepted'
	end
	
	def vote_for
		#puts params
		@frustration = Frustration.find(params[:id])
		@frustration.voitings.create(:user => current_user, :score => params[:score].to_f-1)
		render json: @frustration.voiting_score
	end

	def new 
		@frustration = Frustration.new 

	end

	

	def show
		@negative = params[:negative].nil? ? true : to_bool(params[:negative]) 
		#puts  @negative
		@frustration = Frustration.find(params[:id])
		if expert?
			@accepted_frustrations = Frustration.feed_accepted
			render 'show_for_expert'
		elsif admin?
			render 'show_for_admin'
		else
			render 'show'
		end
	end

	private 

end
