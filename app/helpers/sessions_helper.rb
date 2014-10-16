# encoding: utf-8
module SessionsHelper

	def journal_enter
  		current_user.journals.build(type_event:'enter').save!
  end

	def deny_access 
    store_location
    redirect_to new_user_session_path, notice: "Авторизуйтесь пожалуйста!"
  end

  def have_project_access
    @project = Core::Project.find(params[:project]) if params[:project]
    if @project
      redirect_to :root unless @project.project_access(current_user)
    end
  end

	def have_rights
		# puts "_________________"+params[:project]
    #
		#project = Core::Project.find(params[:project])
		#if (current_user.nil? or !(current_user.projects.include? project))  and project.type_access == 2
		#	redirect_to root_path, :notice: "У вас нет прав просматривать этот проект!"
		#end
  end

  #@todo new permissions
  ##### user.type_user
  # 1 - admin (prime moderator) :)
  # 2 - expert
  # 3 - jury
  # 4 - ratio club user
  # 5 - ratio club watcher
  # 6 - assistant (admin)
  # 7 - tech admin and ratio club user :)
  # 8 - user
  #####

  def boss_authenticate
		deny_access unless boss?
  end

  def prime_admin_authenticate
    redirect_to(root_path) unless prime_admin?
  end


	def redirect_back_or(default)
	    redirect_to(session[:return_to] || default)
	    clear_return_to
	end

	def current_user?(user)
	    user == current_user
	end

	def expert?
    current_user.type_user == 2 unless current_user.nil?
	end	

	def admin?
    [1,6,7].include? current_user.type_user unless current_user.nil?
  end

  def prime_admin?
    [1,7].include? current_user.type_user unless current_user.nil?
  end

  def role_expert?
    current_user.role_stat == 2 unless current_user.nil?
  end

  def jury?
    current_user.type_user == 3 unless current_user.nil?
	end

	def boss?
    [1,2,3,6,7].include? current_user.type_user unless current_user.nil?
	end

  def watcher?
    current_user.type_user == 5 unless current_user.nil?
  end

  def cluber?
    [4,5,7].include? current_user.type_user unless current_user.nil?
  end

  def list_type_projects_for_user
    unless current_user.nil?
      case current_user.type_user
        when 1,7
          [0,1,2,3,4,5]
        when 6
          [0,1,3,4,5]
        when 2,3
          [0,1,3]
        when 4,5
          [0,1,3]
        when 8
          [0,3]
        else
          [0,3]
      end
    else
      [-1]
    end
  end

  def limit_projects_for_user
    unless current_user.nil?
      [1,6,7].include?(current_user.type_user) ? 0 : 2
    else
      0
    end
  end

  def events_ignore
    ["'reply_life_tape_comment'","'reply_discontent_comment'","'reply_concept_comment'","'reply_plan_comment'",
     "'reply_essay_comment'"]
  end

  def user?
		not (admin? or expert?)
	end

  def can_union_discontents?(project)
    project.status == 4 and boss?
  end

	def to_bool(arg)
    return true if arg =~ (/^(true|t|yes|y|1)$/i)
    return false if arg.empty? || arg =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new "invalid value: #{arg}"
  end

  def admin_user
		redirect_to(root_path) if current_user.nil? or not admin?
	end

  private
    
	    def store_location
	      session[:return_to] = request.fullpath
	    end

	    def clear_return_to
	      session[:return_to] = nil
	    end

end
