# encoding: utf-8
class PostsController < ApplicationController
  before_filter :authenticate
  before_filter :prepare_data, :only => [:index, :new, :edit, :show,:vote_list, :to_work]
  before_filter :journal_data, :only => [:index, :new, :edit, :show, :vote_list, :to_work]
  before_filter :have_rights, :only =>[:edit]
  before_filter :have_project_access
  before_filter :not_open_closed_stage

  def authenticate
    unless current_user
      redirect_to '/users/sign_in'
    end
  end

  #def have_project_access
  #  @project = Core::Project.find(params[:project])
  #  if @project
  #    unless @project.project_access(current_user)
  #      redirect_to :root
  #    end
  #  end
  #end

  def not_open_closed_stage
    if params[:project]
      @project = Core::Project.find(params[:project])
      redirect_to polymorphic_path(@project.redirect_to_current_stage) if @project.status < @project.model_min_stage(current_model.table_name.singularize)
    end
  end

  def have_rights
    unless current_model != "Knowbase::Post"
      if current_model.find(params[:id]).user != current_user and not boss?
        redirect_to :back
      end
    end
  end

  def journal_viewed_life_tape
    if params[:viewed]
      Journal.events_for_content(@project, current_user, @aspect.id).update_all("viewed = 'true'")
      @my_journals_count = @my_journals_count - 1
    end
  end

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

  def name_of_note_for_param
    note_model.table_name.singularize
  end

  def root_model_path(project)
    life_tape_posts_path(project)
  end

  def voting_model
    Discontent::Post
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
  end

  def add_comment
    @project = Core::Project.find(params[:project])
    @aspects = Discontent::Aspect.where(:project_id => @project)
    post = current_model.find(params[:id])
    @main_comment = comment_model.find(params[:main_comment]) unless params[:main_comment].nil?
    main_comment_answer = comment_model.find(params[:answer_id]) unless params[:answer_id].nil?
    comment_user = main_comment_answer.user unless main_comment_answer.nil?
    content = comment_user ? "#{comment_user.to_s}, " + params[name_of_comment_for_param][:content] : params[name_of_comment_for_param][:content]
    unless  params[name_of_comment_for_param][:content]==''
      @comment = post.comments.create(:content => content, :user =>current_user,:discontent_status => params[name_of_comment_for_param][:discontent_status],:concept_status => params[name_of_comment_for_param][:concept_status], :comment_id => @main_comment ? @main_comment.id : nil)
      #@todo новости и информирование авторов
      current_user.journals.build(:type_event=>name_of_comment_for_param+'_save', :project => @project,
                                  :body=>"#{trim_content(@comment.content)}", :body2=>trim_content(field_for_journal(post)),
                                  :first_id=> (post.instance_of? LifeTape::Post) ? post.discontent_aspects.first.id : post.id, :second_id => @comment.id).save!

      if post.user!=current_user
        current_user.journals.build(:type_event=>'my_'+name_of_comment_for_param, :user_informed => post.user, :project => @project,
                                    :body=>"#{trim_content(@comment.content)}", :body2=>trim_content(field_for_journal(post)),
                                    :first_id=> (post.instance_of? LifeTape::Post) ? post.discontent_aspects.first.id : post.id, :second_id => @comment.id,
                                    :personal=> true, :viewed=> false).save!
      end
      if @main_comment and @main_comment.user!=current_user
        current_user.journals.build(:type_event=>'reply_'+name_of_comment_for_param, :user_informed =>@main_comment.user, :project => @project,
                                    :body=>"#{trim_content(@comment.content)}", :body2=>trim_content(@main_comment.content),
                                    :first_id=> (post.instance_of? LifeTape::Post) ? post.discontent_aspects.first.id : post.id, :second_id => @comment.id,
                                    :personal=> true, :viewed=> false).save!
      end
      if main_comment_answer and main_comment_answer.user!=current_user
        current_user.journals.build(:type_event=>'reply_'+name_of_comment_for_param, :user_informed => main_comment_answer.user, :project => @project,
                                    :body=>"#{trim_content(@comment.content)}", :body2=>trim_content(main_comment_answer.content),
                                    :first_id=> (post.instance_of? LifeTape::Post) ? post.discontent_aspects.first.id : post.id, :second_id => @comment.id,
                                    :personal=> true, :viewed=> false).save!
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def add_child_comment_form
    @project = Core::Project.find(params[:project])
    @post = current_model.find(params[:id])
    @main_comment = comment_model.find(params[:comment_id])
    main_comment_answer = comment_model.find(params[:answer_id]) unless params[:answer_id].nil?
    @comment = comment_model.new
    @url_link = url_for(:controller => @post.class.name.underscore.pluralize, :action => 'add_comment', :main_comment => @main_comment.id, :answer_id => main_comment_answer ? main_comment_answer.id : nil)
    respond_to do |format|
      format.js
    end
  end

  def comment_status
    @project = Core::Project.find(params[:project])
    @post = current_model.find(params[:id])
    #@todo безопасность
    if params[:comment_stage]
      @comment = "#{get_class_for_improve(params[:comment_stage].to_i)}::Comment".constantize.find(params[:comment_id]) unless params[:comment_id].nil?
    end
    @comment.toggle!(:discontent_status) if params[:discontent]
    @comment.toggle!(:concept_status) if params[:concept]
    @comment.toggle!(:discuss_status) if params[:discuss_status]
    if @comment.discuss_status
      current_user.journals.build(:type_event=>name_of_comment_for_param+'_discuss_stat', :project => @project,
                                  :body=>"#{trim_content(@comment.content)}", :body2=>trim_content(field_for_journal(@post)),
                                  :first_id=> (@post.instance_of? LifeTape::Post) ? @post.discontent_aspects.first.id : @post.id, :second_id => @comment.id).save!

      if @comment.user!=current_user
        current_user.journals.build(:type_event=>'my_'+name_of_comment_for_param+'_discuss_stat', :user_informed => @comment.user, :project => @project,
                                    :body=>"#{trim_content(@comment.content)}", :body2=>trim_content(field_for_journal(@post)),
                                    :first_id=> (@post.instance_of? LifeTape::Post) ? @post.discontent_aspects.first.id : @post.id, :second_id => @comment.id,
                                    :personal=> true, :viewed=> false).save!
      end
    end
    respond_to do |format|
      format.js
    end
  end
  def discuss_status
    @project = Core::Project.find(params[:project])
    @post = current_model.find(params[:id])
    if params[:discuss_status]
      @post.toggle!(:discuss_status)
      if @post.discuss_status
        current_user.journals.build(:type_event=>name_of_model_for_param+'_discuss_stat', :project => @project,
                                  :body=>"#{trim_content(@post.content)}", :first_id=> @post.id).save!
        if @post.user!=current_user
          current_user.journals.build(:type_event=>'my_'+name_of_model_for_param+'_discuss_stat', :user_informed => @post.user, :project => @project,
                                      :body=>"#{trim_content(@post.content)}", :first_id=> @post.id, :personal=> true, :viewed=> false).save!
        end
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def index
    @posts = current_model.where(:project_id => @project).paginate(:page => params[:page])
    respond_to do |format|
      format.html
    end
  end

  def show
    @post = current_model.where(:id => params[:id], :project_id => params[:project]).first
    if params[:viewed]
      Journal.events_for_content(@project, current_user, @post.id).update_all("viewed = 'true'")
      @my_journals_count = @my_journals_count - 1
    end
    per_page = ["Concept","Essay"].include?(@post.class.name.deconstantize) ? 10 : 30
    @comments = @post.main_comments.paginate(:page => params[:page] ? params[:page] : last_page, :per_page => per_page)

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
    page == 0 ? 1 :page
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
      @project = Core::Project.find(params[:project]) 
      @post = current_model.new(params[name_of_model_for_param])
      @post.project = @project
      @post.user = current_user

      @post.stage = params[:stage] unless params[:stage].nil?
      @post.discontent_aspects  << Discontent::Aspect.find(params[:aspect_id]) unless params[:aspect_id].nil?
      @post.style = params[:style] unless params[:style].nil?
      @post.status = 0 if current_model.column_names.include? 'status'

      respond_to do |format|
        if @post.save
          current_user.journals.build(:type_event=>name_of_model_for_param+"_save", :project => @project, :body=>trim_content(@post.content), :first_id => @post.id).save!
          current_user.add_score_by_type(@project, 50, :score_a)

          format.html { redirect_to  :action=>'show', :id => @post.id, :project => @project }
          format.js
        else
          format.html { render action: "new" }
          format.js
        end
      end
    
  end

  def update
    @post = current_model.find(params[:id])
    @project = Core::Project.find(params[:project]) 

    respond_to do |format|
      if @post.update_attributes(params[name_of_model_for_param])
        unless params[:aspect_id].nil?
          @post.discontent_aspects.delete_all
          @post.discontent_aspects << Discontent::Aspect.find(params[:aspect_id])
        end
        @post.update_attribute(:style,params[:style]) unless params[:style].nil?

        format.html { redirect_to  :action=>'show', :project => @project, :id => @post.id }
        format.js
      else
        format.html { render action: "edit" }
      end
    end
  end


  def destroy
    @post = current_model.find(params[:id])
    @post.destroy
    @project = Core::Project.find(params[:project]) 

    respond_to do |format|
      format.html { redirect_to root_model_path(@project) }
      format.json { head :no_content }
    end
  end

  def to_archive
    @post = current_model.find(params[:id])
    @post.update_column(:status, 3)

    @project = Core::Project.find(params[:project]) 

    respond_to do |format|
      format.html { redirect_to url_for(:controller => @post.class.to_s.tableize, :action => :index) }
      format.json { head :no_content }
    end
  end

  #todo check if user already voted
  def plus
    post = current_model.find(params[:id])
    @project= Core::Project.find(params[:project])

    @against =  params[:against] == 'true'

    if boss? and post.admins_vote.count != 0
      post.admins_vote.destroy_all
      @admin_pro= true
    else
      post.post_votings.create(:user => current_user, :post => post, :against => @against)  unless post.users.include? current_user
      if (current_user.boss? or post.post_votings.count == 3) and not @against
        Award.reward(user: post.user, post: post, project: @project, type: 'add')
        post.user.add_score(:type => :plus_post, :project => Core::Project.find(params[:project]), :post => post, :path =>  post.class.name.underscore.pluralize)
      end
    end
    if post.instance_of? Discontent::Post
      post.update_attributes(:status_content => true, :status_whered => true,:status_whend => true)
    elsif post.instance_of? Concept::Post
      post.update_attributes(:stat_name => true, :stat_content => true,:stat_positive => true,:stat_positive_r => true, :stat_negative => true,:stat_negative_r => true,:stat_problems => true,:stat_reality => true)
    end

    @id= post.id
    @post_vote = post
    respond_to do |format|
      format.js
    end
  end

  def plus_comment
    @id = params[:id]
    @project= Core::Project.find(params[:project])
    comment = comment_model.find(@id)
    @against =  params[:against] == 'true'
    comment.comment_votings.create(:user => current_user, :comment => comment,  :against => @against) unless comment.users.include? current_user
    comment.user.add_score(:type => :plus_comment, :project => @project, :comment => comment, :path =>  comment.post.class.name.underscore.pluralize)  if current_user.boss? or comment.comment_votings.count == 3
    Award.reward(user: comment.user, project: @project, type: 'like')
    @main_comment = comment.comment.id unless comment.comment.nil?
    respond_to do |format|
      format.js
    end
  end

  ### function for voiting
  #return list model for voiting, check stages
  def vote_list
    @posts = voting_model.where(:project_id => @project)
  end


  #write fact of voting in db
  def vote
    @project = Core::Project.find(params[:project])
    @post_vote = voting_model.find(params[:post_id])
    @post_vote.final_votings.create(:user => current_user)
    stage = "#{self.class.name.deconstantize.downcase}"
    @number_v = @project.get_free_votes_for(current_user, stage)
    @table_name = current_model.table_name.sub('_posts','/posts')
  end

  def new_note
    @project = Core::Project.find(params[:project])
    @post = current_model.find(params[:id])
    @type = params[:type_field]
    @post_note = note_model.new
  end

  def create_note
    @project = Core::Project.find(params[:project])
    @post = current_model.find(params[:id])
    @type = params[name_of_note_for_param][:type_field]
    @post_note = @post.notes.build(params[name_of_note_for_param])
    @post_note.user = current_user

    current_user.journals.build(:type_event=>'my_'+name_of_note_for_param, :user_informed => @post.user, :project => @project, :body => trim_content(@post_note.content), :first_id => @post.id, :personal => true, :viewed=> false).save!

    @post.update_attributes(column_for_type_field(name_of_note_for_param, @type.to_i) => 'f')

    respond_to do |format|
      if @post_note.save
        format.js
      else
        format.js { render action: "new_note" }
      end
    end
  end

  def destroy_note
    @project = Core::Project.find(params[:project])
    @post = current_model.find(params[:id])
    @type = params[:type_field]
    @post_note = note_model.find(params[:note_id])
    @post_note.destroy if boss?
  end

  def status_post
    @project = Core::Project.find(params[:project])
    @post = current_model.find(params[:id])
    @type = params[:type_field]
    if @post.notes(@type.to_i).size == 0
      @post.update_attributes(column_for_type_field(name_of_note_for_param, @type.to_i) => 't')
    end
    respond_to do |format|
      format.js
    end
  end

  def censored
    if boss?
      post = current_model.find(params[:post_id])
      post.update_column(:censored, true)
    end
  end

  def censored_comment
    if boss?
      comment = comment_model.find(params[:id])
      comment.update_column(:censored, true)
    end
  end

  def edit_comment
    @comment = comment_model.find(params[:id])
  end

  def update_comment
    @comment = comment_model.find(params[:id])
    respond_to do |format|
      if @comment.update_attributes(content: params[:content])
        format.js
      end
    end
  end

  def destroy_comment
    @project = Core::Project.find(params[:project])
    @comment = comment_model.find(params[:id])
    @comment.destroy if @comment.user == current_user or current_user.boss?
  end

  def set_important
    @project = Core::Project.find(params[:project])
    @post = current_model.find(params[:id])
    @post.toggle!(:important)
  end

  def check_field
    @project = Core::Project.find(params[:project])
    if !params[:check_field].nil? and !params[:status].nil?
      current_user.user_checks.where(project_id: @project.id,check_field: params[:check_field]).destroy_all
      current_user.user_checks.create(project_id: @project.id, check_field: params[:check_field], status: params[:status]).save!
    end
    head :ok
  end

  def to_work

  end

  def vote_result

  end

end
