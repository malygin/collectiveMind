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
			end
			if @frustration.save
				flash[:success] = "Недовольство добавлено в список!"
				redirect_to root_path
			else
				@frustrations_feed=[]
				render "pages/home"
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
		unless @frustration.struct_user.nil?
			@frustration.user.update_column(:score, @frustration.user.score + Settings.scores.expert.allow*0.6)
			@frustration.struct_user.update_column(:score, @frustration.struct_user.score + Settings.scores.expert.allow*0.4)
		else
			@frustration.user.update_column(:score, @frustration.user.score + Settings.scores.expert.allow)
		end
		flash[:success] = "Недовольство принято"
		redirect_to user_path(current_user)
	end

	def expert_decline
		@frustration = Frustration.find(params[:id])
		@frustration.update_column(:status, 5)
		#if we have negative comments - ban 
		unless @frustration.comments_after_structuring.empty?
			@frustration.user.update_column(:score, @frustration.user.score + Settings.scores.expert.deny_with_negative)
		end
		flash[:success] = "Недовольство отклонено"
		redirect_to user_path(current_user)
	end

	def edit_to_struct
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

		@frustration.update_attributes(:what_old => @frustration.what,
			:wherin_old => @frustration.wherin,
			:when_old => @frustration.when,
			:content_text_old => @frustration.content_text,
			:struct_user => @user, 
			:what => params[:frustration][:what],
			:wherin => params[:frustration][:wherin],
			:when => params[:frustration][:when],
			:structuring_date => Time.now, :status => 2 )
		flash[:success] = "Недовольство  формализовано"
		redirect_to root_path
	end

	def show
		@negative = params[:negative].nil? ? true : to_bool(params[:negative]) 
		#puts  @negative
		@frustration = Frustration.find(params[:id])
	end

	private 

end
