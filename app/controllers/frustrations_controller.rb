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

#todo check author of comment - true?

	def archive
		#puts "_______"
		if not params[:author_comment].nil?
			@user = User.where(:id => (params[:author_comment])).first
			#puts @user.score
			new_score = @user.score+Settings.scores.unstructure.denial_for_negative_comment
			#puts new_score
			@user.update_attribute(:score, new_score)
		end
		@frustration = Frustration.find(params[:id])
		@frustration.update_attribute(:status,1) 
		@frustration.update_attribute(:negative_user, @user)
		flash[:success] = "Отправлена в архив!"
		redirect_to root_path
	end

	def edit_to_struct
		@frustration = Frustration.find(params[:id])
		@author_comment = params[:author_comment]
	end

	def update_to_struct
		@frustration = Frustration.find(params[:id])
		@user = User.where(:id => (params[:author_comment])).first
		puts @user
		@frustration.update_attributes(:what_old => @frustration.what,
			:wherin_old => @frustration.wherin,
			:when_old => @frustration.when, 
			:struct_user => @user, 
			:what => params[:frustration][:what],
			:wherin => params[:frustration][:wherin],
			:when => params[:frustration][:when],
			:structuring_date => Time.now, :status => 2 )
		flash[:success] = "Неудовлетворенность переведена в структурированные"
		redirect_to root_path
	end

	def show
		@negative = params[:negative].nil? ? true : to_bool(params[:negative]) 
		#puts  @negative
		@frustration = Frustration.find(params[:id])
	end

	private 
		def authorized_user
			@frustration = current_user.frustrations.find_by_id(params[:id])
			redirect_to root_path if @frustration.nil?
		end
		def to_bool(arg)
		    return true if arg =~ (/^(true|t|yes|y|1)$/i)
		    return false if arg.empty? || arg =~ (/^(false|f|no|n|0)$/i)
		    raise ArgumentError.new "invalid value: #{arg}"
	    end
end
