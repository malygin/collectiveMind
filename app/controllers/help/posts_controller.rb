class Help::PostsController < PostsController
  before_filter :project_by_id

  def  project_by_id
    unless params[:project].nil?
      @project = Core::Project.find(params[:project])
    end
    add_breadcrumb I18n.t('menu.help'), help_posts_path(@project)
  end

  def index
    redirect_to help_post_path(@project, id:1)
  end

  def show
    @stages = Core::Project::LIST_STAGES
    @posts={}
    id =params[:id].to_i
    Help::Post.where(stage: id, mini: false).each {|f| @posts[f.style] = f }
    add_breadcrumb  @stages[id][:name], help_post_path(@project, id)
  end

  def save_help_answer
    params['question'].each do |k|
      current_user.help_users_answerses.build(answer_id: k[1].to_i)
    end
    current_user.save
    redirect_to :back
  end

end
