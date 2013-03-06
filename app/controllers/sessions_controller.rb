# encoding: utf-8
class SessionsController < ApplicationController
    layout 'core/projects'

  def new
  end

  def create
    #puts params
  	user = User.authenticate(params[:session][:email], params[:session][:password])
  	if user.nil?
  		flash.now[:error] = "Ошибка авторизации!"
  		render 'new'
  	else
  		sign_in user
      journal_enter 
  		redirect_back_or '/estimate/result'
  	end
  end



  def destroy
  	sign_out
  	redirect_to root_path
  end

 

end
