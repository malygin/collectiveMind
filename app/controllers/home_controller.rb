class HomeController < ApplicationController
  layout 'core/projects'

  def index
    if signed_in?
      if prime_admin?
        @closed_projects = Core::Project.where(type_access: Core::Project::TYPE_ACCESS[:closed][:code])
      elsif boss?
        @closed_projects = current_user.projects.where(core_projects: {type_access: Core::Project::TYPE_ACCESS[:closed][:code]})
      else
        @closed_projects = current_user.projects.where(core_projects: {type_access: Core::Project::TYPE_ACCESS[:closed][:code]})
      end
      @core_projects = current_user.current_projects_for_user
      @core_project = @core_projects.last
      @opened_projects = Core::Project.where(type_access:  Core::Project::TYPE_ACCESS[:opened][:code])
    end
  end
end
