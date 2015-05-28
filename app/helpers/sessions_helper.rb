module SessionsHelper
  def journal_enter
    current_user.journals.build(type_event: 'enter').save!
  end


  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def current_user?(user)
    user == current_user
  end


  def boss?
    not current_user.nil? and current_user.type_user == 1
  end



  private

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end
end
