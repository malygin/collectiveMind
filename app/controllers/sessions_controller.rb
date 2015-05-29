class SessionsController < ApplicationController
  layout 'core/projects'

  def new
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = 'Ошибка авторизации!'
      render 'new'
    else
      sign_in user
      journal_enter
      redirect_back_or '/'
    end
    respond_to :js, :html
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
