# encoding: utf-8
class PostsController < ApplicationController
  before_filter :authenticate
  before_filter :prepare_data, :only => [:index, :new, :edit, :show, :show_essay, 
    :vote_list, :essay_list]
  before_filter :journal_data, :only => [:index, :new, :edit, :show, :show_essay,
    :vote_list, :essay_list, :to_work]
  #before_filter :have_rights
  before_filter :have_rights, :only =>[:edit]
  before_filter :to_work_redirect, only: [:index]



  # before_filter :authorized_user, :only => :destroy
 def authenticate
   unless current_user
     redirect_to '/users/sign_in'
   end
 end
 def have_rights
   unless current_model != "Knowbase::Post"
     if  current_model.find(params[:id]).user != current_user and not boss?
       redirect_to :back
     end
   end
 end


  def current_model
    "#{self.class.name.deconstantize}::Post".constantize
  end

  def comment_model
    "#{self.class.name.deconstantize}::Comment".constantize
  end


def note_model
  "#{self.class.name.deconstantize}::PostNote".constantize
end


def name_of_model_for_param
	current_model.table_name.singularize
end

def name_of_comment_for_param
	comment_model.table_name.singularize
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

def to_work_redirect
  @project = Core::Project.find(params[:project])
  path_link = "/project/#{@project.id}/" + current_model.table_name.sub('_posts','/posts') + "/to_work"
  able = ['life_tape_posts','discontent_posts','concept_posts'].include? current_model.table_name
  check = get_check_field?(current_model.table_name + '_to_work')
  redirect_to path_link if params[:asp].nil? and able and !check or params[:help]
end

  def add_comment
    @project = Core::Project.find(params[:project])
    @aspects = Discontent::Aspect.where(:project_id => @project)
    post = current_model.find(params[:id])
    @main_comment = comment_model.find(params[:main_comment]) unless params[:main_comment].nil?
    @comment_user = User.find(params[:comment_user]) unless params[:comment_user].nil?
    if @comment_user
      content = "#{@comment_user.to_s}, " + params[name_of_comment_for_param][:content]
    else
      content = params[name_of_comment_for_param][:content]
    end
    dis_stat = params[name_of_comment_for_param][:dis_stat]
    con_stat = params[name_of_comment_for_param][:con_stat]
    unless  params[name_of_comment_for_param][:content]==''
      @comment = post.comments.create(:content => content, :user =>current_user,:dis_stat => dis_stat,:con_stat => con_stat, :comment_id => @main_comment ? @main_comment.id : nil)
      current_user.journals.build(:type_event=>name_of_comment_for_param+'_save', :project => @project,
                                  :body=>"#{trim_content(@comment.content)}", :body2=>trim_content((post.instance_of? LifeTape::Post) ? post.discontent_aspects.first.content : post.content),
                                  :first_id=> (post.instance_of? LifeTape::Post) ? post.discontent_aspects.first.id : post.id, :second_id => @comment.id).save!

      #PostMailer.add_comment(post, @comment).deliver  if post.user!=@comment.user
      if post.user!=current_user
        current_user.journals.build(:type_event=>'my_'+name_of_comment_for_param, :user_informed => post.user, :project => @project,
                                    :body=>"#{trim_content(@comment.content)}", :body2=>trim_content((post.instance_of? LifeTape::Post) ? post.discontent_aspects.first.content : post.content),
                                    :first_id=> (post.instance_of? LifeTape::Post) ? post.discontent_aspects.first.id : post.id, :second_id => @comment.id,
                                    :personal=> true, :viewed=> false).save!
      end
      if @main_comment and @main_comment.user!=current_user
        current_user.journals.build(:type_event=>'reply_'+name_of_comment_for_param, :user_informed =>@main_comment.user, :project => @project,
                                    :body=>"#{trim_content(@comment.content)}", :body2=>trim_content(@main_comment.content),
                                    :first_id=> (post.instance_of? LifeTape::Post) ? post.discontent_aspects.first.id : post.id, :second_id => @comment.id,
                                    :personal=> true, :viewed=> false).save!
      end

    end
    respond_to do |format|
      format.js
    end
    #redirect_to polymorphic_path(post, :project => @project.id)
  end

  def add_child_comment_form
    @project = Core::Project.find(params[:project])
    @post = current_model.find(params[:id])
    @main_comment = comment_model.find(params[:comment_id])
    @comment_user = User.find(params[:comment_user]) unless params[:comment_user].nil?
    @comment = comment_model.new
    if @comment_user
      @url_link = url_for(:controller => @post.class.name.underscore.pluralize, :action => 'add_comment', :main_comment => @main_comment.id, :comment_user => @comment_user.id)
      #@url_link = "/project/#{@project.id}/" + current_model.table_name.sub('_posts','/posts') + "/#{@post.id}/add_comment?main_comment=#{@main_comment.id}&comment_user=#{@comment_user.id}"
    else
      @url_link = url_for(:controller => @post.class.name.underscore.pluralize, :action => 'add_comment', :main_comment => @main_comment.id)
      #@url_link = "/project/#{@project.id}/" + current_model.table_name.sub('_posts','/posts') + "/#{@post.id}/add_comment?main_comment=#{@main_comment.id}"
    end
    respond_to do |format|
      format.js
    end
  end

  def comment_stat
    @project = Core::Project.find(params[:project])
    @post = current_model.find(params[:id])
    @comment = comment_model.find(params[:comment_id])
    if params[:dis_stat].present?
      @comment.toggle(:dis_stat)
      @comment.update_attributes(dis_stat: @comment.dis_stat)
    end
    if params[:con_stat].present?
      @comment.toggle(:con_stat)
      @comment.update_attributes(con_stat: @comment.con_stat)
    end
    respond_to do |format|
      format.js
    end
  end

def index
    @posts = current_model.where(:project_id => @project).paginate(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /discontent/posts/1
  # GET /discontent/posts/1.json
  def show
    @post = current_model.where(:id => params[:id], :project_id => params[:project]).first
    add_breadcrumb 'Просмотр записи', polymorphic_path(@post, :project => @project.id)
    if params[:viewed]
      Journal.events_for_content(@project, current_user, @post.id).update_all("viewed = 'true'")
      @my_journals_count = @my_journals_count - 1
    end
    per_page = ["Concept","Essay"].include?(@post.class.name.deconstantize) ? 10 : 30
    @comments = @post.comments.where(:comment_id => nil).paginate(:page => params[:page] ? params[:page] : last_page, :per_page => per_page)
    #puts "___________"
    #puts @post
    # @path_link ='/'+ self.class.to_s.split("::").first.tableize.singularize+'/comments/'

    if current_model.column_names.include? 'number_views'
      @post.update_column(:number_views, @post.number_views+1)
    end
    @comment = comment_model.new
    respond_to do |format|
      format.html { render :layout => 'application_two_column'} # show.html.erb
      format.json { render json: @post }
      format.js
    end
  end

  def last_page
    total_results = @post.comments.where(:comment_id => nil).count
    page = total_results / 10 + (total_results % 10 == 0 ? 0 : 1)
    page == 0 ? 1 :page
  end

  def show_essay
    @post = Essay::Post.find(params[:id])
     @post.update_column(:number_views, @post.number_views+1)

    @comment = Essay::Comment.new  
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /discontent/posts/new
  # GET /discontent/posts/new.json
  def new
    @post = current_model.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /discontent/posts/1/edit
  def edit
    @post = current_model.find(params[:id])
    if @post.user != current_user  and not boss?
      redirect_to life_tape_posts_path(@project)
    end
  end

  # POST /discontent/posts
  # POST /discontent/posts.json
  def create
      @project = Core::Project.find(params[:project]) 
      @post = current_model.new(params[name_of_model_for_param])
      @post.project = @project
      @post.user = current_user
      unless params[:stage].nil?
        @post.stage = params[:stage]
      end     
      unless params[:aspect_id].nil?
        @post.discontent_aspects  << Discontent::Aspect.find(params[:aspect_id])
      end
      unless params[:style].nil?
        @post.style = params[:style]
      end
      if current_model.column_names.include? 'status'
        @post.status = 0
      end
      respond_to do |format|
        if @post.save
          current_user.journals.build(:type_event=>name_of_model_for_param+"_save", :project => @project, :body=>"#{@post.content[0..24]}:#{@post.id}").save!

          format.js
          format.html {
            unless params[:replace].nil?
              params[:replace].each do |k,v|
                @post.post_replaces.build(:replace_id => k).save
              end
            end
            flash[:succes] = 'Успешно добавлено!'

            redirect_to  :action=>'show', :id => @post.id, :project => @project  }
          format.json { render json: @post, status: :created, location: @post }
        else
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
          format.js
        end
      end
    
  end

  # PUT /discontent/posts/1
  # PUT /discontent/posts/1.json
  def update
    @post = current_model.find(params[:id])
    @project = Core::Project.find(params[:project]) 

    respond_to do |format|
      if @post.update_attributes(params[name_of_model_for_param])
        unless params[:aspect_id].nil?
          @post.discontent_aspects.delete_all
          @post.discontent_aspects << Discontent::Aspect.find(params[:aspect_id])

        end
        unless params[:style].nil?
          @post.update_attribute(:style,params[:style])
        end
        unless params[:replace].nil?
          @post.post_replaces.destroy_all
          params[:replace].each do |k,v|
            @post.post_replaces.build(:replace_id => k).save
          end
          #@post.replace_id = params[:replace_id]

        end
        format.html { 
          flash[:success] = 'Успешно добавлено!'
          redirect_to  :action=>'show', :project => @project, :id => @post.id}
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discontent/posts/1
  # DELETE /discontent/posts/1.json
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
    @against =  params[:against] == 'true'

    if boss? and post.admins_vote.count != 0
      post.admins_vote.destroy_all
      @admin_pro= true

    else
      post.post_votings.create(:user => current_user, :post => post, :against => @against)  unless post.users.include? current_user
      if (current_user.boss? or post.post_votings.count == 3) and not @against
        post.user.add_score(:type => :plus_post, :project => Core::Project.find(params[:project]), :post => post, :path =>  post.class.name.underscore.pluralize)
      end
    end

    @id= post.id
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

  def essay_list
    @posts = Essay::Post.where(params[:stage])
    @post = Essay::Post.new
  end

  #write fact of voting in db
  def vote
    @project = Core::Project.find(params[:project])
    @post_vote = voting_model.find(params[:post_id])
    @post_vote.final_votings.create(:user => current_user)
    stage = "#{self.class.name.deconstantize.downcase}"
    @number_v = @project.get_free_votes_for(current_user, stage, @project)
    @table_name = current_model.table_name.sub('_posts','/posts')
    #@votes = @project.stage3 - current_user.concept_post_votings.count
  end

### function for dialog with expert


  def to_expert
    prepare_data
    @note = Concept::PostNote.new
  end 

  def expert_rejection
    prepare_data
    @note = Concept::PostNote.new
  end 
  
  def expert_revision
    prepare_data
    @note = Concept::PostNote.new
  end 

  def save_note(params, status, message, type_event)

    post = current_model.find(params[:id])
    if !params[:concept_post_note].nil? and params[:concept_post_note][:content]!= ''
      @note = note_model.new(params[:concept_post_note])
      @note.post = post
      @note.user = current_user
      @note.save
    end
    post.update_column(:status, status)
    current_user.journals.build(:type_event=>type_event,  :project => Core::Project.find(params[:project]), :body=>post.id).save!
    flash[:notice]=message
    post
  end

  def to_expert_save
    save_note(params, 1, 'Отправлено эксперту!',name_of_model_for_param+'_to_expert' )
    redirect_to  action: "index"    
  end

  def expert_rejection_save
    save_note(params, 3, 'Отклонено!',name_of_model_for_param+'_rejection' )
    redirect_to  action: "index"
  end

  def expert_acceptance_save
    post = save_note(params, 2, 'Принято!',name_of_model_for_param+'_acceptance' )
    if post.post_replaced.empty?
      post.user.add_score(100)
    else
      post.user.add_score(200)
      post.post_replaced.each do |rp|
        rp.update_column(:status, 3)
      end
    end
    redirect_to  action: "index"
  end

  def expert_revision_save
    save_note(params, 0, 'Отправлена на доработку!',name_of_model_for_param+'_revision' )
    redirect_to  action: "index"
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
    if @comment.update_attributes(content: params[:content])
      respond_to do |format|
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
    @post.toggle(:important)
    @post.update_attributes(important: @post.important)

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
    @project = Core::Project.find(params[:project])
    if current_model == "LifeTape"
      if @project.aspects.first
        @path_link = "/project/#{@project.id}/" + current_model.table_name.sub('_posts','/posts') + "?asp=#{@project.aspects.first.id}"
      else
        @path_link = "/project/#{@project.id}/" + current_model.table_name.sub('_posts','/posts')
      end
    else
      if @project.proc_aspects.first
        @path_link = "/project/#{@project.id}/" + current_model.table_name.sub('_posts','/posts') + "?asp=#{@project.proc_aspects.first.id}"
      else
        @path_link = "/project/#{@project.id}/" + current_model.table_name.sub('_posts','/posts')
      end
    end
    @table_name = current_model.table_name.sub('_posts','')

    respond_to do |format|
      format.html { render :layout => 'application_two_column'}
    end
  end

  protected

  def load_filter_for_aspects
    current_user.discontent_aspect_users.destroy_all
    unless params[:aspects_filter].nil?
      params[:aspects_filter].each do |asp|
        current_user.discontent_aspect_users.create(aspect_id: asp.to_i)
      end
    end
  end
end
