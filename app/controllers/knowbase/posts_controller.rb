class Knowbase::PostsController < ApplicationController
  layout "application_two_column"
  before_filter :project_by_id

  def  project_by_id
    unless params[:project].nil?
      @project = Core::Project.find(params[:project])
    end
    add_breadcrumb I18n.t('menu.base_knowledge'), knowbase_posts_path(@project)

  end

  def index
    redirect_to knowbase_post_path(@project, id:1)
  end

  def show
    @stages = @project.knowbase_posts
    @post =Knowbase::Post.where(project_id: @project.id, stage: params[:id]).first
    add_breadcrumb  @post.title, knowbase_post_path(@project, @post.id)
  end



end
