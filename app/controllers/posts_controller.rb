class PostsController < ProjectsController
  include PostComments
  # include PostNotes
  layout 'cabinet', only: [:new, :edit, :user_content]

  before_filter :journal_data, only: [:index, :new, :edit, :show,  :about, :user_content]
  before_filter :check_type_mechanics, only: [:new, :edit, :user_content]
  before_filter :check_stage_for_cabinet, only: [:new, :edit, :user_content]
  before_filter :author_or_boss?, only: [:edit, :destroy, :to_archive, :publish]
  before_filter :boss?, only: [:add_score, :change_status]

  def current_model
    "#{self.class.name.deconstantize}::Post".constantize
  end

  def comment_model
    "#{self.class.name.deconstantize}::Comment".constantize
  end

  def name_of_model_for_param
    current_model.table_name.singularize
  end

  def name_of_comment_for_param
    comment_model.table_name.singularize
  end

  # def note_model
  #   "#{self.class.name.deconstantize}::Note".constantize
  # end
  # def name_of_note_for_param
  #   note_model.table_name.singularize
  # end

  def voting_model
    Discontent::Post
  end

  def index
    @posts = current_model.where(project_id: @project).paginate(page: params[:page])
    respond_to :html
  end

  def show
    @post = current_model.prepare_to_show(params[:id], @project.id, params[:viewed])
    @questions = Core::ContentQuestion.where(project_id: @project, post_type: name_of_model_for_param)
    @comments = @post.main_comments
    @comment = comment_model.new
    @last_time_visit = params[:last_time_visit]
    respond_to do |format|
      format.html { redirect_to url_for(controller: @post.class.to_s == 'Core::Aspect::Post' ? '/collect_info/posts' : @post.class.to_s.tableize, action: :index, jr_post: @post.id) }
      format.json { render json: @post }
      format.js
    end
  end

  def new
    @post = current_model.new
    respond_to :html
  end

  def edit
    @post = current_model.find(params[:id])
  end

  def create
    @post = current_model.create_post(params, @project, current_user)
    respond_to :html, :js
  end

  def update
    @post = current_model.find(params[:id])
    respond_to do |format|
      if @post.update_attributes(params[name_of_model_for_param])
        format.html { redirect_to action: 'show', project: @project, id: @post.id }
        format.js
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @post = current_model.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to current_stage_url(@project) }
      format.json { head :no_content }
    end
  end

  def autocomplete
    results = current_model.autocomplete params[:term]
    render json: results
  end

  def user_content
    @content = current_model.by_project(@project).by_user(current_user)
    @stage_comments = comment_model.by_user(current_user).stage_comments_for(@project)
  end

  def publish
    @post = current_model.find params[:id]
    @post.update status: current_model::STATUSES[:published]
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
    Journal.like_event(current_user, @project, name_of_model_for_param, @post, @against)
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
    @question = Core::ContentQuestion.find(params[:question_id])
    current_user.core_content_user_answers.create(post_id: params[:id], content_question_id: @question.id, content_answer_id: params[:answers].first.to_i, content: params[:content]).save!
  end

  def change_status
    @post = current_model.find(params[:id])
    @post.change_status_by current_user, params
    respond_to :js
  end

  private

  def check_stage_for_cabinet
    #  check if user reload url for old-stage cabinet, and procedure on new stage - redirect to new stage
    return if @project.current_stage_type == params[:controller].sub('/', '_').to_sym ||
              action_name == 'user_content' || @project.current_stage_type == :collect_info_posts && params[:controller].sub('/', '_').to_sym == :'core_aspect/posts'
    redirect_to url_for(params.merge(controller: '/' + @project.current_stage_type.to_s.sub('_', '/')))
  end

  def check_type_mechanics
    # check if we use possible mechanic or use default
    if params[:type_mechanic].present? && correct_mechanic?
      @mechanic_type = params[:type_mechanic]
    else
      @mechanic_type = 'simple'
    end
  end

  def correct_mechanic?
    Technique::List.by_stage(current_model.to_s.sub('Core::', '').sub('::', '_').underscore.pluralize).where(code: params[:type_mechanic]).any?
  end

  def journal_data
    if params[:viewed]
      post = current_model.where(id: params[:id], project_id: @project.id).first if params[:id]
      post_id = if current_model.to_s == 'CollectInfo::Post'
                  params[:asp] ? Core::Aspect::Post.find(params[:asp]) : @project.aspects.order(:id).first
                else
                  post
                end
      if params[:req_comment]
        Journal.events_for_comment(@project, current_user, post_id.id, params[:req_comment].to_i).update_all(viewed: true) if post_id
      else
        Journal.events_for_content(@project, current_user, post_id.id).update_all(viewed: true) if post_id
      end
    end
    super()
  end

  def boss?
    redirect_to "/project/#{@project.id}"  unless  current_user && current_user.boss?
  end

  def author_or_boss?
    post = current_model.find(params[:id])
    redirect_to "/project/#{@project.id}" if (current_user != post.user) && (!current_user.boss?)
  end
end
