class PostsController < ProjectsController
  before_filter :journal_data, only: [:index, :new, :edit, :show, :vote_result, :to_work, :about]
  before_filter :have_project_access
  before_filter :boss_authenticate, only: [:vote_result]
  before_filter :comment_page, only: [:index, :show]

  def autocomplete
    results = current_model.autocomplete params[:term]
    render json: results
  end

  def journal_data
    if params[:viewed]
      post = current_model.where(id: params[:id], project_id: @project.id).first if params[:id]
      post_id = if current_model.to_s == 'CollectInfo::Post' then
                  params[:asp] ? Core::Aspect.find(params[:asp]) : @project.aspects.order(:id).first
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

  def current_model
    "#{self.class.name.deconstantize}::Post".constantize
  end

  def comment_model
    "#{self.class.name.deconstantize}::Comment".constantize
  end

  def note_model
    "#{self.class.name.deconstantize}::Note".constantize
  end

  def name_of_model_for_param
    current_model.table_name.singularize
  end

  def name_of_comment_for_param
    comment_model.table_name.singularize
  end

  def name_of_note_for_param
    note_model.table_name.singularize
  end

  def root_model_path(project)
    life_tape_posts_path(project)
  end

  def voting_model
    Discontent::Post
  end

  def add_comment
    @aspects = Core::Aspect.where(project_id: @project)
    post = current_model.find(params[:id])
    if params[:advise_status]
      create_advice post
    else
      create_comment post
    end
  end

  def comment_status
    @post = current_model.find(params[:id])
    #@todo безопасность
    if params[:comment_stage]
      @comment = get_comment_for_stage(params[:comment_stage], params[:comment_id].to_i) unless params[:comment_id].nil?
    end
    @comment.toggle!(:discontent_status) if params[:discontent]
    @comment.toggle!(:concept_status) if params[:concept]
    @comment.toggle!(:discuss_status) if params[:discuss_status]
    @comment.toggle!(:approve_status) if params[:approve_status]
    if params[:discuss_status]
      if @comment.discuss_status
        type = 'discuss_status'
      end
    elsif params[:approve_status]
      if @comment.approve_status
        type = 'approve_status'
      end
    end
    if type
      current_user.journals.build(type_event: name_of_comment_for_param+'_'+type, project: @project,
                                  body: "#{trim_content(@comment.content)}", body2: trim_content(field_for_journal(@post)),
                                  first_id: (@post.instance_of? LifeTape::Post) ? @post.core_aspects.first.id : @post.id, second_id: @comment.id).save!

      if @comment.user!=current_user
        current_user.journals.build(type_event: 'my_'+name_of_comment_for_param+'_'+type, user_informed: @comment.user, project: @project,
                                    body: "#{trim_content(@comment.content)}", body2: trim_content(field_for_journal(@post)),
                                    first_id: (@post.instance_of? LifeTape::Post) ? @post.core_aspects.first.id : @post.id, second_id: @comment.id,
                                    personal: true, viewed: false).save!
      end
      if @project.closed?
        Resque.enqueue(CommentNotification, current_model.to_s, @project.id, current_user.id, name_of_comment_for_param, type, @post.id, @comment.id, params[:comment_stage])
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def discuss_status
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
    respond_to do |format|
      format.html
    end
  end

  def show
    @post = current_model.where(id: params[:id], project_id: params[:project]).first
    if params[:viewed]
      Journal.events_for_content(@project, current_user, @post.id).update_all("viewed = 'true'")
      # @my_journals_count = @my_journals_count - 1
    end
    # per_page = ["Concept", "Essay"].include?(@post.class.name.deconstantize) ? 10 : 30
    @comments = @post.main_comments.paginate(page: params[:page] ? params[:page] : last_page, per_page: 10)

    if current_model.column_names.include? 'number_views'
      @post.update_column(:number_views, @post.number_views.nil? ? 1 : @post.number_views+1)
    end
    @comment = comment_model.new
    respond_to do |format|
      format.html
      format.json { render json: @post }
      format.js
    end
  end

  def last_page
    total_results = @post.main_comments.count
    page = total_results / 10 + (total_results % 10 == 0 ? 0 : 1)
    page == 0 ? 1 : page
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
    @post.core_aspects << Core::Aspect.find(params[:aspect_id]) unless params[:aspect_id].nil?
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
          @post.core_aspects << Core::Aspect.find(params[:aspect_id])
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
    @post = current_model.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to root_model_path(@project) }
      format.json { head :no_content }
    end
  end

  def to_archive
    @post = current_model.find(params[:id])
    @post.update_column(:status, 3)

    respond_to do |format|
      format.html { redirect_to url_for(controller: @post.class.to_s.tableize, action: :index) }
      format.json { head :no_content }
    end
  end

  #todo check if user already voted
  def plus
    @post = current_model.find(params[:id])
    if boss? or role_expert?
      @post.toggle!(:useful)
      if @post.useful
        @post.user.add_score(type: :plus_post, project: @project, post: @post, path: @post.class.name.underscore.pluralize)
        Award.reward(user: @post.user, post: @post, project: @project, type: 'add')
      else
        @post.user.add_score(type: :to_archive_plus_post, project: @project, post: @post, path: @post.class.name.underscore.pluralize)
        Award.reward(user: @post.user, post: @post, project: @project, type: 'remove')
      end
    end
    if @post.instance_of? Discontent::Post
      @post.update_attributes(status_content: true, status_whered: true, status_whend: true)
      # elsif @post.instance_of? Concept::Post
      #   @post.update_attributes(status_name: true, status_content: true, status_positive: true, status_positive_r: true, status_negative: true, status_negative_r: true, status_problems: true, status_reality: true, status_positive_s: true, status_negative_s: true, status_control: true, status_control_r: true, status_control_s: true, status_obstacles: true)
    end

    #@against =  params[:against] == 'true'
    #if boss? and post.admins_vote.count != 0
    #  post.admins_vote.destroy_all
    #  @admin_pro= true
    #else
    #  post.post_votings.create(user: current_user, post: post, against: @against)  unless post.users.include? current_user
    #  if (current_user.boss? or post.post_votings.count == 3) and not @against
    #    Award.reward(user: post.user, post: post, project: @project, type: 'add')
    #    post.user.add_score(type: :plus_post, project: Core::Project.find(params[:project]), post: post, path:  post.class.name.underscore.pluralize)
    #  end
    #end
    respond_to do |format|
      format.js
    end
  end

  def plus_comment
    @id = params[:id]
    @comment = comment_model.find(@id)
    #@against =  params[:against] == 'true'
    #comment.comment_votings.create(user: current_user, comment: comment,  against: @against) unless comment.users.include? current_user
    if boss? or role_expert?
      @comment.toggle!(:useful)
      if @comment.useful
        @comment.user.add_score(type: :plus_comment, project: @project, comment: @comment, path: @comment.post.class.name.underscore.pluralize)
        Award.reward(user: @comment.user, project: @project, type: 'like')
      else
        @comment.user.add_score(type: :to_archive_plus_comment, project: @project, comment: @comment, path: @comment.post.class.name.underscore.pluralize)
        Award.reward(user: @comment.user, project: @project, type: 'unlike')
      end
    end
    @main_comment = @comment.comment.id unless @comment.comment.nil?
    respond_to do |format|
      format.js
    end
  end


  def like
    @post = current_model.find(params[:id])
    @against = params[:against]
    @vote = @post.post_votings.create(user: current_user, post: @post, against: @against) unless @post.users.include? current_user
    respond_to do |format|
      format.js
    end
  end

  def like_comment
    @comment = comment_model.find(params[:id])
    @against = params[:against]
    @vote = @comment.comment_votings.create(user: current_user, comment: @comment, against: @against) unless @comment.users.include? current_user
    respond_to do |format|
      format.js
    end
  end

  #write fact of voting in db
  def vote
    @post_vote = voting_model.find(params[:id])
    @post_vote.final_votings.create(user: current_user, status: params[:status])

    # @post_vote = voting_model.find(params[:post_id])
    #
    # #@todo Денис, нужно правильно задать атрибут через life_tape_voiting_params, чтобы сохранялся current_user
    # @post_vote.final_votings.create(user: current_user)
    #
    # stage = "#{self.class.name.deconstantize.downcase}"
    # @number_v = @project.get_free_votes_for(current_user, stage)
    # @table_name = current_model.table_name.sub('_posts', '/posts')
  end

  def new_note
    @post = current_model.find(params[:id])
    @type = params[:type_field]
    @post_note = note_model.new
  end

  def create_note
    @post = current_model.find(params[:id])
    @type = params[name_of_note_for_param][:type_field]
    @post_note = @post.notes.build(params[name_of_note_for_param])
    @post_note.user = current_user

    current_user.journals.build(type_event: 'my_'+name_of_note_for_param, user_informed: @post.user, project: @project, body: trim_content(@post_note.content), first_id: @post.id, personal: true, viewed: false).save!

    @post.update_attributes(column_for_type_field(name_of_note_for_param, @type.to_i) => 'f')
    if @type and @post.instance_of? Concept::Post and @post.send(column_for_type_field(name_of_note_for_param, @type.to_i)) == true
      @post.user.add_score(type: :to_archive_plus_field, project: @project, post: @post, path: @post.class.name.underscore.pluralize, type_field: column_for_type_field(name_of_note_for_param, @type.to_i))
    end

    respond_to do |format|
      if @post_note.save
        format.js
      else
        format.js { render action: "new_note" }
      end
    end
  end

  def destroy_note
    @post = current_model.find(params[:id])
    @type = params[:type_field]
    @post_note = note_model.find(params[:note_id])
    @post_note.destroy if boss?
  end

  def status_post
    @post = current_model.find(params[:id])
    @type = params[:type_field]
    @field_all = params[:field_all]
    @statuses = []
    if params[:field_all] and @post.instance_of? Concept::Post
      @post.toggle!(:status_all)
      if @post.status_all
        @statuses = @post.update_statuses
        # @post.update_attributes(status_name: true, status_content: true, status_positive: true, status_positive_r: true, status_negative: true, status_negative_r: true, status_control: true, status_control_r: true, status_obstacles: true, status_problems: true, status_reality: true)
        @post.user.add_score(type: :plus_field_all, project: @project, post: @post, path: @post.class.name.underscore.pluralize) if @post.instance_of? Concept::Post
      else
        @post.update_attributes(status_name: nil, status_content: nil, status_positive: nil, status_positive_r: nil, status_negative: nil, status_negative_r: nil, status_control: nil, status_control_r: nil, status_obstacles: nil, status_problems: nil, status_reality: nil)
        @post.user.add_score(type: :to_archive_plus_field_all, project: @project, post: @post, path: @post.class.name.underscore.pluralize) if @post.instance_of? Concept::Post
      end
    elsif @type and @post.send(column_for_type_field(name_of_note_for_param, @type.to_i)) == true
      @post.update_attributes(column_for_type_field(name_of_note_for_param, @type.to_i) => nil)
      # @post.user.add_score(type: :to_archive_plus_field, project: @project, post: @post, path: @post.class.name.underscore.pluralize, type_field: column_for_type_field(name_of_note_for_param, @type.to_i)) if @post.instance_of? Concept::Post
    elsif @post.notes.by_type(@type.to_i).size == 0
      @post.update_attributes(column_for_type_field(name_of_note_for_param, @type.to_i) => 't')
      # @post.user.add_score(type: :plus_field, project: @project, post: @post, path: @post.class.name.underscore.pluralize, type_field: column_for_type_field(name_of_note_for_param, @type.to_i)) if @post.instance_of? Concept::Post
    end
    @post.save!
    respond_to do |format|
      format.js
    end
  end

  # def censored
  #   if boss?
  #     post = current_model.find(params[:post_id])
  #     post.update_column(:censored, true)
  #   end
  # end
  #
  # def censored_comment
  #   if boss?
  #     comment = comment_model.find(params[:id])
  #     comment.update_column(:censored, true)
  #   end
  # end

  def edit_comment
    @comment = comment_model.find(params[:id])
  end

  def update_comment
    @comment = comment_model.find(params[:id])
    @aspects = Core::Aspect.where(project_id: @project)

    if params[:image]
      if ['image/jpeg', 'image/png'].include? params[:image].content_type
        img = Cloudinary::Uploader.upload(params[:image], folder: 'comments', crop: :limit, width: 800,
                                          eager: [{crop: :fill, width: 150, height: 150}])
        isFile = false
      else
        img = Cloudinary::Uploader.upload(params[:image], folder: 'comments', resource_type: :raw)
        isFile = true
      end
    end

    respond_to do |format|

      @comment.update_attributes(content: params[:content])
      if params[:image]
        @comment.update_attributes(image: img ? img['public_id'] : nil, isFile: img ? isFile : nil)
      end
      format.js

    end
  end

  def destroy_comment
    @comment = comment_model.find(params[:id])
    if @comment.user == current_user or current_user.boss?
      @comment.destroy
      #@todo удаление комментариев из ленты
      Journal.destroy_comment_journal(@project, @comment)
    else
      redirect_to root_url
    end
  end

  def check_field
    if params[:check_field] and params[:status]
      current_user.user_checks.where(project_id: @project.id, check_field: params[:check_field]).destroy_all
      current_user.user_checks.create(project_id: @project.id, check_field: params[:check_field], status: params[:status]).save!
    end
    head :ok
  end

  def comment_page
    if params[:req_comment] and params[:page].nil?
      stage = params[:controller].sub('/posts', '') if params[:controller]
      if stage
        post = stage == "collect_info" ? params[:asp] : params[:id]
        page = page_for_comment(params[:project], stage, post, params[:req_comment])
      end
      path = page ? request.fullpath + "&page=#{page}#comment_#{params[:req_comment]}" : request.fullpath + "#comment_#{params[:req_comment]}"
      redirect_to path
    end
  end

  # def sort_aspects
  #   @project.set_position_for_aspects if @project.status == 3
  # end
  private
  def create_advice(post)
    @advice = post.advices.new content: params[name_of_comment_for_param][:content]
    @advice.user = current_user
    @advice.project = @project
    @advice.save
    @advice.notify_moderators(@project, current_user)

    render template: 'posts/add_advice'
  end

  def create_comment(post)
    if params[:main_comment]
      @comment_answer = comment_model.find(params[:main_comment]) unless params[:main_comment].nil?
      @comment_parent = @comment_answer.comment ? @comment_answer.comment : @comment_answer
    end
    content = params[name_of_comment_for_param][:content]

    if params[name_of_comment_for_param][:image]
      img, isFile = Util::ImageLoader.load(params[name_of_comment_for_param])
    end

    unless content==''
      @comment = post.comments.create(content: content, image: img ? img['public_id'] : nil, isFile: img ? isFile : nil,
                                      user: current_user, comment_id: @comment_parent ? @comment_parent.id : nil)

      Journal.comment_event(current_user, @project, name_of_comment_for_param, post, @comment, @comment_answer)
    end
    @new_comment = comment_model.new
    render template: 'posts/add_comment'
  end
end
