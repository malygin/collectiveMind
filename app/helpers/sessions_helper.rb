# encoding: utf-8
module SessionsHelper

	def sign_in(user)
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]
		self.current_user = user
	end

	def sign_out
		cookies.delete(:remember_token)
		self.current_user = nil
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= user_from_remember_token
	end

	def signed_in?
		!current_user.nil?
	end

	def deny_access 
	    store_location
	    redirect_to signin_path, :notice => "Войди сначала!"
	end

	def authenticate
		deny_access unless signed_in?
	end

	def redirect_back_or(default)
	    redirect_to(session[:return_to] || default)
	    clear_return_to
	end

	def current_user?(user)
	    user == current_user
	end

	def expert?
		current_user.expert unless current_user.nil?
	end

	def authorized_user
			@frustration = current_user.frustrations.find_by_id(params[:id])
			redirect_to root_path if @frustration.nil?
	end

	def to_bool(arg)
		    return true if arg =~ (/^(true|t|yes|y|1)$/i)
		    return false if arg.empty? || arg =~ (/^(false|f|no|n|0)$/i)
		    raise ArgumentError.new "invalid value: #{arg}"
    end

  private
    
	    def store_location
	      session[:return_to] = request.fullpath
	    end

	    def clear_return_to
	      session[:return_to] = nil
	    end


		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
		end

		def remember_token
			cookies.signed[:remember_token] || [nil, nil]
		end

end
