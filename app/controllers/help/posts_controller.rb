class Help::PostsController < ApplicationController
  layout "application_three_column"
  before_filter :project_by_id

  def  project_by_id
    unless params[:project].nil?
      @project = Core::Project.find(params[:project])
    end
    add_breadcrumb I18n.t('menu.help'), help_posts_path(@project)

  end

  def index
    @stages = Core::Project::LIST_STAGES
    @post = Help::Post.find(1)
  end

  def show
    @stages = Core::Project::LIST_STAGES
    @posts={}
    Help::Post.where(stage: params[:id]).each {
        |f| @posts[f.style] = f }
    add_breadcrumb  @stages[params[:id].to_i][:name], help_post_path(@project, params[:id])

  end

  def save_help_answer
    params['question'].each do |q, k|
      current_user.help_users_answerses.build(answer_id: k.keys[0].to_i)
    end
    current_user.save
    render :nothing => true
  end

end
