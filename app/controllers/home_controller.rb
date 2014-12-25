class HomeController < ApplicationController
  def index
    if signed_in?
      if prime_admin?
        @closed_projects = Core::Project.where(type_access: Core::Project::TYPE_ACCESS_CODE[:closed])
      elsif boss?
        @closed_projects = current_user.projects.where(core_projects: {type_access: Core::Project::TYPE_ACCESS_CODE[:closed]})
      else
        @closed_projects = current_user.projects.where(core_projects: {type_access: Core::Project::TYPE_ACCESS_CODE[:closed]})
      end
      @core_projects = current_user.current_projects_for_user
      @core_project = @core_projects.last
      @club_projects = Core::Project.where(type_access: Core::Project::TYPE_ACCESS_CODE[:club]) if cluber? or boss?
      @opened_projects = Core::Project.where(type_access: Core::Project::TYPE_ACCESS_CODE[:opened])
    end
  end
end
