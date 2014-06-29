class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include ApplicationHelper
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end
  def journal_data
    @project = Core::Project.find(params[:project])
    events  = Journal.events_for_my_feed @project.id, current_user.id
    g = events.group_by { |e| e.first_id }
    @my_journals=g.collect{|k,v| [v.first, v.size]}
    @my_journals_count = @my_journals.size
  end
end
