class PostsController < ProjectsController
  include PostComments
  # include PostNotes
  layout 'cabinet', only: [:new, :edit, :user_content]

  before_filter :journal_data, only: [:index, :new, :edit, :show,  :about, :user_content]
  before_filter :check_type_mechanics, only: [:new, :edit, :user_content]
  before_filter :check_stage_for_cabinet, only: [:new, :edit, :user_content]

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

  def journal_data
    if params[:viewed]
      post = current_model.where(id: params[:id], project_id: @project.id).first if params[:id]
      post_id = if current_model.to_s == 'CollectInfo::Post' then
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




  def change_status
    @post = current_model.find(params[:id])

    if params[:discuss_status]
      @post.toggle!(:discuss_status)
      if @post.discuss_status
        type = 'discuss_status'
      end
    elsif params[:approve_status]
      @post.toggle!(:approve_status)
      if @post.approve_status
        type = 'approve_status'
      end
    end
    if type
      current_user.journals.build(type_event: name_of_model_for_param+'_'+type, project: @project,
                                  body: "#{trim_content(field_for_journal(@post))}", first_id: @post.id).save!
      if @post.user!=current_user
        current_user.journals.build(type_event: 'my_'+name_of_model_for_param+'_'+type, user_informed: @post.user, project: @project,
                                    body: "#{trim_content(field_for_journal(@post))}", first_id: @post.id, personal: true, viewed: false).save!
      end
      if @project.closed?
        Resque.enqueue(PostNotification, current_model.to_s, @project.id, current_user.id, name_of_model_for_param, type, @post.id)
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def index
    @posts = current_model.where(project_id: @project).paginate(page: params[:page])
    respond_to :html
  end

  def show
    @post = current_model.where(id: params[:id], project_id: params[:project]).first
    if params[:viewed]
      Journal.events_for_content(@project, current_user, @post.id).update_all("viewed = 'true'")
      # @my_journals_count = @my_journals_count - 1
    end
    # per_page = ["Concept", "Essay"].include?(@post.class.name.deconstantize) ? 10 : 30
    @comments = @post.main_comments
    @questions = Core::ContentQuestion.where(project_id: @project, post_type: name_of_model_for_param)

    if current_model.column_names.include? 'number_views'
      @post.update_column(:number_views, @post.number_views.nil? ? 1 : @post.number_views+1)
    end
    @comment = comment_model.new
    respond_to do |format|
      format.html { redirect_to url_for(controller: @post.class.to_s == "Core::Aspect::Post" ? '/collect_info/posts' : @post.class.to_s.tableize, action: :index, jr_post: @post.id) }
      format.json { render json: @post }
      format.js
    end
  end



  def new
    @post = current_model.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @post = current_model.find(params[:id])
    if @post.user != current_user and not boss?
      redirect_to life_tape_posts_path(@project)
    end
  end

  def create
    @post = current_model.new(params[name_of_model_for_param])
    @post.project = @project
    @post.user = current_user

    @post.stage = params[:stage] unless params[:stage].nil?
    @post.core_aspects << Core::Aspect::Post.find(params[:aspect_id]) unless params[:aspect_id].nil?
    @post.style = params[:style] unless params[:style].nil?
    @post.status = 0 if current_model.column_names.include? 'status'

    respond_to do |format|
      if @post.save
        current_user.journals.build(type_event: name_of_model_for_param+"_save", project: @project, body: @post.content == '' ? t('link.more') : trim_content(@post.content), first_id: @post.id).save!
        # current_user.add_score_by_type(@project, 50, :score_a)

        format.html { redirect_to action: 'show', id: @post.id, project: @project }
        format.js
      else
        format.html { render action: "new" }
        format.js
      end
    end

  end

  def update
    @post = current_model.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[name_of_model_for_param])
        unless params[:aspect_id].nil?
          @post.core_aspects.delete_all
          @post.core_aspects << Core::Aspect::Post.find(params[:aspect_id])
        end
        @post.update_attribute(:style, params[:style]) unless params[:style].nil?

        format.html { redirect_to action: 'show', project: @project, id: @post.id }
        format.js
      else
        format.html { render action: "edit" }
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

  def to_archive
    @post = current_model.find(params[:id]).update_column(:status, 3)
    respond_to do |format|
      format.html { redirect_to url_for(controller: @post.class.to_s.tableize, action: :index) }
      format.json { head :no_content }
    end
  end

  #todo check if user already voted
  def add_score
    @post = current_model.find(params[:id])
    if current_user.boss? or current_user.role_expert? or current_user.stat_expert?
      @post.toggle!(:useful)
      if @post.user
        if @post.useful
          @post.user.add_score(type: :plus_post, project: @project, post: @post, type_score: "#{@post.class.table_name == 'core_aspect_posts' ? 'collect_info_posts' : @post.class.table_name}_score", score: current_model::SCORE, model_score: @post.class.table_name.singularize)
        else
          @post.user.add_score(type: :to_archive_plus_post, project: @project, post: @post, type_score: "#{@post.class.table_name == 'core_aspect_posts' ? 'collect_info_posts' : @post.class.table_name}_score", score: current_model::SCORE, model_score: @post.class.table_name.singularize)
        end
      end
    end
    respond_to :js
  end




  def like
    @post = current_model.find(params[:id])
    @against = params[:against]
    @vote = @post.post_votings.create(user: current_user, post: @post, against: @against) unless @post.users.include? current_user
    Journal.like_event(current_user, @project, name_of_model_for_param, @post, @against)
    respond_to do |format|
      format.js
    end
  end



  #write fact of voting in db
  def vote
    @post_vote = voting_model.find(params[:id])
    saved_vote = @post_vote.final_votings.where(user_id: current_user)
    if @post_vote.instance_of? Plan::Post
      saved_vote.where(type_vote: params[:type_vote].to_i).destroy_all
      @post_vote.final_votings.create(user: current_user, type_vote: params[:type_vote], status: params[:status]).save!
    else
      if saved_vote.present?
        vote = saved_vote.first
        if vote.status != params[:status].to_i
          saved_vote.destroy_all
          @post_vote.final_votings.create(user: current_user, status: params[:status]).save!
        elsif vote.status == params[:status].to_i
          saved_vote.destroy_all
        end
      else
        @post_vote.final_votings.create(user: current_user, status: params[:status]).save!
      end
    end

  end

  def check_field
    if params[:check_field] and params[:check_field]!='' and params[:status]
      current_user.user_checks.where(project_id: @project.id, check_field: params[:check_field]).destroy_all
      current_user.user_checks.create(project_id: @project.id, check_field: params[:check_field], status: params[:status]).save!
    end
    head :ok
  end


  def answer_content_question
    @question = Core::ContentQuestion.find(params[:question_id])
    current_user.core_content_user_answers.create(post_id: params[:id], content_question_id: @question.id, content_answer_id: params[:answers].first.to_i, content: params[:content]).save!
  end




  private
  # @todo add test for this
  def check_stage_for_cabinet
    #  check if user reload url for old-stage cabinet, and procedure on new stage - redirect to new stage
    unless @project.current_stage_type == params[:controller].sub('/', '_').to_sym
      unless @project.current_stage_type == :collect_info_posts and params[:controller].sub('/', '_').to_sym == :'core_aspect/posts'
        unless action_name == 'user_content'
          redirect_to url_for(params.merge(controller: '/'+@project.current_stage_type.to_s.sub('_', '/')))
        end
      end
    end
  end

  def check_type_mechanics
    # check if we use possible mechanic or use default
    if params[:type_mechanic].present? and correct_mechanic?
      @mechanic_type = params[:type_mechanic]
    else
      @mechanic_type = 'simple'
    end
  end

  def correct_mechanic?
    Technique::List.by_stage(current_model.to_s.sub('Core::', '').sub('::', '_').underscore.pluralize).where(code: params[:type_mechanic]).any?
  end


end
