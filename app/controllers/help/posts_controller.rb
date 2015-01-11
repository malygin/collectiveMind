class Help::PostsController < PostsController
  before_filter :prepare_data
  before_filter :user_projects

  def current_model
    Help::Post
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
  end

  def index
    redirect_to help_post_path(@project, id:1)
  end

  def show
    @stages = Core::Project::LIST_STAGES
    @posts = {}
    @help_partial_1 = case params[:id]
                      when '0'
                         'new_help_0'
                      when '1'
                        'new_help_1'
                      when '2'
                        'new_help_2'
                      when '3'
                        'new_help_3'
                      when '4'
                        'new_help_4'
                      when '5'
                        'new_help_5'
                      when '6'
                        'new_help_6'
                      else
                        'new_help_0'
                    end
    @help_partial_2 = case params[:id]
                      when '0'
                        'new_help_0'
                      when '1'
                        'new_help_1_s'
                      when '2'
                        'new_help_2_s'
                      when '3'
                        'new_help_3_s'
                      when '4'
                        'new_help_4_s'
                      when '5'
                        'new_help_5_s'
                      when '6'
                        'new_help_6'
                      else
                        'new_help_0'
                    end
    # Help::Post.where(stage: id, mini: false).each {|f| @posts[f.style] = f }
  end
end
