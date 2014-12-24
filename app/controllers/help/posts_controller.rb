class Help::PostsController < PostsController
  def current_model
    Help::Post
  end

  def index
    redirect_to help_post_path(@project, id: 1)
  end

  def show
    @stages = Core::Project::LIST_STAGES
    @posts = {}
    @help_partial = case params[:id]
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
                      else
                        'new_help_5'

                    end

    # Help::Post.where(stage: id, mini: false).each {|f| @posts[f.style] = f }
  end
end
