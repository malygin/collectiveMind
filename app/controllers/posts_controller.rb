class PostsController < ProjectsController
  include PostComments
  include PostCabinet
  # include PostNotes
  layout 'cabinet', only: [:new, :edit, :user_content]

  before_filter :author_or_boss?, only: [:edit, :destroy, :to_archive, :publish]
  before_filter :boss?, only: [:add_score, :change_status]

  def current_model
    "#{self.class.name.deconstantize}::Post".constantize
  end

  def comment_model
    "#{self.class.name.deconstantize}::Comment".constantize
  end

  def voting_model
    "#{self.class.name.deconstantize}::Post".constantize
  end

  def name_of_model_for_param
    current_model.table_name.singularize
  end

  def name_of_comment_for_param
    comment_model.table_name.singularize
  end

  def index
    @posts = current_model.where(project_id: @project).paginate(page: params[:page])
    respond_to :html
  end

  def show
    @post = current_model.prepare_to_show(params[:id], @project.id, params[:viewed])
    @questions = Core::Content::Question.where(project_id: @project, post_type: name_of_model_for_param)
    @comments = @post.main_comments
    @comment = comment_model.new
    @last_time_visit = params[:last_time_visit]
    respond_to :html, :js
  end

  def autocomplete
    results = current_model.autocomplete params[:term]
    render json: results
  end

  def to_archive
    @post = current_model.find(params[:id]).update_column(:status, 3)
    respond_to do |format|
      format.html { redirect_to url_for(controller: @post.class.to_s.tableize, action: :index) }
      format.json { head :no_content }
    end
  end

  def add_score
    @post = current_model.find(params[:id])
    @post.add_score
    respond_to :js
  end

  def like
    @post = current_model.find(params[:id])
    @against = params[:against]
    @vote = @post.post_votings.create(user: current_user, post: @post, against: @against) unless @post.users.include? current_user
    JournalEventSaver.like_event(user: current_user, project: @project.project, post: @post, against: @against)
    respond_to :js
  end

  def vote
    @post_vote = voting_model.find(params[:id])
    @post_vote.vote(current_user, params[:status])
  end

  def check_field
    if params[:check_field] && params[:check_field] != '' && params[:status]
      current_user.user_checks.where(project_id: @project.id, check_field: params[:check_field]).destroy_all
      current_user.user_checks.create(project_id: @project.id, check_field: params[:check_field], status: params[:status]).save!
    end
    head :ok
  end

  def answer_content_question
    @question = Core::Content::Question.find(params[:question_id])
    current_user.core_content_user_answers.create(post_id: params[:id], content_question_id: @question.id,
                                                  content_answer_id: params[:answers].first.to_i, content: params[:content]).save!
  end

  def change_status
    @post = current_model.find(params[:id])
    @post.change_status_by current_user, params
    respond_to :js
  end

  def show_results
    current_user.user_checks.where(project_id: @project.id, check_field: 'results_' + self.class.to_s.gsub('::', '_')
                                                                                          .gsub('Controller', '').underscore, status: true).first_or_create
  end

  def user_vote
    return unless current_user.can_vote_for(@project) && name_controller == @project.current_stage_type
    @user_voter = UserDecorator.new current_user
    @count_all_posts, @count_voted_posts = @user_voter.count_posts_for_progress(@project)
  end

  private

  def name_controller
    self.class.to_s.gsub('::', '_').gsub('Controller', '').underscore.to_sym
  end

  def boss?
    redirect_to "/project/#{@project.id}" unless current_user && current_user.boss?
  end

  def author_or_boss?
    post = current_model.find(params[:id])
    redirect_to "/project/#{@project.id}" if (current_user != post.user) && (!current_user.boss?)
  end
end
