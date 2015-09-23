class HomeController < ApplicationController
  layout 'core/projects'

  def index
    return unless signed_in?
    if boss?
      @closed_projects = Core::Project.where(type_access: Core::Project::TYPE_ACCESS[:closed][:code])
    else
      @closed_projects = current_user.projects.where(core_projects: { type_access: Core::Project::TYPE_ACCESS[:closed][:code] })
    end
    @opened_projects = Core::Project.where(type_access: Core::Project::TYPE_ACCESS[:opened][:code])
  end
end
