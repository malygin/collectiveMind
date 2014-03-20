class Knowbase::PostsController < ApplicationController
  layout "application_two_column"
  before_filter :project_by_id

  def current_model
    Knowbase::Post
  end

  def  project_by_id
    unless params[:project].nil?
      @project = Core::Project.find(params[:project])
    end
    add_breadcrumb I18n.t('menu.base_knowledge'), knowbase_posts_path(@project)
  end

  def index
    #redirect_to knowbase_post_path(@project, id:1)

    @stages = current_model.stage_knowbase_order(@project.id)
    @post = current_model.stage_knowbase_post(@project.id, 1).first
    add_breadcrumb  @post.title, knowbase_post_path(@project, @post.id)
    render "show"

  end

  def show
    @stages = current_model.stage_knowbase_order(@project.id)
    @post = current_model.stage_knowbase_post(@project.id, params[:id]).first
    add_breadcrumb  @post.title, knowbase_post_path(@project, @post.id)
  end

end
