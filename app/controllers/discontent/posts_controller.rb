# encoding: utf-8
require 'similar_text'
require 'set'

class Discontent::PostsController < PostsController
  # GET /discontent/posts
  # GET /discontent/posts.json

  autocomplete :discontent_post, :whend, :class_name => 'Discontent::Post' , :full => true
  autocomplete :discontent_post, :whered, :class_name => 'Discontent::Post' , :full => true

  #def get_autocomplete_items(parameters)
  #  items = super(parameters)
  #  items = items.where(:project_id => params[:project])
  #end

  def autocomplete_discontent_post_whend
    pr=Set.new
    pr.merge(Discontent::PostWhen.where(:project_id => params[:project]).map {|d| {:value => d.content}})
    if params[:term].length > -1
      pr.merge(Discontent::Post.select("DISTINCT whend as value").where("LOWER(whend) like LOWER(?)", "%#{params[:term]}%")
               .where(:project_id => params[:project]).map {|d| {:value => d.value } })
    end
    render json: pr
  end

 def autocomplete_discontent_post_whered
    pr=Set.new
    pr.merge(Discontent::PostWhere.where(:project_id => params[:project]).map {|d| {:value => d.content}})
    if params[:term].length > -1
      pr.merge(Discontent::Post.select("DISTINCT whered as value").where("LOWER(whered) like LOWER(?)", "%#{params[:term]}%")
               .where(:project_id => params[:project]).map {|d| {:value => d.value } })
    end
    render json: pr
  end


  def voting_model  
    Discontent::Post
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
    add_breadcrumb I18n.t('stages.discontent'), discontent_posts_path(@project)

    #@news = ExpertNews::Post.where(:project_id => @project).first
    @status = params[:status]
    @aspect = params[:aspect]
    @aspects = Discontent::Aspect.where(:project_id => @project, :status => 0) #.eager_load(:aspect_posts)
    #@mini_help = Help::Post.where(stage:2, mini: true).first

    #@post_star = []
    @post_star = Discontent::Post.where(:project_id => @project, :important => 't' ).limit(3)
    #Discontent::Post.where(:project_id => @project, :important => 't' ).limit(3)
    @post_dis = Discontent::Post.
        where(:project_id => @project).
        reorder('number_views DESC').
        limit(3)
    if @project.status == 6
      @vote_all = Discontent::Voting.where("discontent_votings.discontent_post_id IN (#{@project.discontents.by_status(2).pluck(:id).join(", ")})").uniq_user.count
    end
  end

  def index
    if @project.status == 6 and !@project.get_united_posts_for_vote(current_user).empty?
      redirect_to action: "vote_list"
      return
    end
    if params[:asp]
      @aspect_post =  Discontent::Aspect.find(params[:asp])
    else
      @aspect_post = @project.proc_aspects.first
    end
    #@post = current_model.new
    @order = params[:order]
    @page = params[:page]
    @folder = :discontent
    @status = 0
    @status = 2 if @project.status == 6
    @status = 1 if @project.status > 6
    #load_filter_for_aspects   if (request.xhr? and @order.nil? and @page.nil?)

    #@posts  = current_model.where(:project_id => @project, :status => 0)
    #.where(status: @status)
    #.order_by_param(@order)
    #.paginate(:page => params[:page], :per_page => 40).eager_load(:discontent_post_aspects)
    #.where('aspect_id  IN (?) ' , current_user.aspects(@project.id).collect(&:id))
    respond_to do |format|
      format.html {
       if params[:view] == 'list'
         render  'index'
       else
         render  'table', layout: 'application_two_column'
       end
      }
      format.js {render 'posts/index'}
    end
  end

 def new
    @asp = Discontent::Aspect.find(params[:asp]) unless params[:asp].nil?
    @post = current_model.new
    @replace_posts =[]
    @accepted_posts = Discontent::Post.where(status: 2, project_id:  @project)
    @users_rc = User.where(admin:false, type_user: 4)

    unless params[:replace_id].nil?
      @replace_posts << current_model.find(params[:replace_id])
    end
    respond_to do |format|
      format.html {render  layout: 'application_two_column'}
      format.json { render json: @post }
    end
  end

  # GET /discontent/posts/1/edit
  def edit
    @post = current_model.find(params[:id])
    @aspects_for_post = @post.post_aspects
    respond_to do |format|
      format.html {render  layout: 'application_two_column'}
      format.js
    end
  end


  def vote_list

    #@posts = current_model.where(:project_id => @project, :status => 2)
    @posts = @project.get_united_posts_for_vote(current_user)

    @post_all = current_model.where(:project_id => @project, :status => 2).count
    if @posts.empty?
      redirect_to action: "index"
      return
    end

    @votes = current_user.voted_discontent_posts.where(:project_id => @project).count
    @status = 2
    #if boss?
    #  @all_people = @project.users.size
    #  @voted_people = ActiveRecord::Base.connection.execute("select count(*) as r from (select distinct v.user_id from discontent_voitings v  left join   discontent_aspects asp on (v.discontent_aspect_id = asp.id) where asp.project_id = #{@project.id}) as dm").first["r"]
    #  @votes = ActiveRecord::Base.connection.execute("select count(*) as r from (select  v.user_id from discontent_voitings v  left join   discontent_aspects asp on (v.discontent_aspect_id = asp.id) where asp.project_id = #{@project.id}) as dm").first["r"].to_i
    #end
    render 'vote_list', :layout => 'application_two_column'
  end


  def my
    prepare_data
    @posts = current_model.where(:project_id => @project, :status => 0, :user_id => current_user).where("created_at < ?", 2.day.ago)
    @posts2 = current_model.where(:project_id => @project, :status => 0, :user_id => current_user).where("created_at >= ?", 2.day.ago)
    @review_posts = current_model.where(:project_id => @project, :status => 1, :user_id => current_user)
    @accepted_posts = current_model.where(:project_id => @project, :status => 2, :user_id => current_user)

    @posts = current_user.discontent_posts.for_project(@project.id).ready_for_post
    @posts2 =  current_user.discontent_posts.for_project(@project.id).not_ready_for_post
    @review_posts = current_user.discontent_posts.for_project(@project.id).for_expert
    @accepted_posts = current_user.discontent_posts.for_project(@project.id).accepted
    @achived_posts =current_user.discontent_posts.for_project(@project.id).archive
    render 'my', :layout => 'application_two_column'
  end

  def create
    @project = Core::Project.find(params[:project])
    #@post = @project.discontents.create(params[name_of_model_for_param])
    #@post.user = current_user
    #discontents = Discontent::Post.where(:project_id => @project.id)
    @flash = view_context.validate_dispost(params[name_of_model_for_param],params[:discontent_post_aspects])
    # r=nil
    # if params[:resave].nil? or !(@flash.nil? or @flash.empty?)
    #   r = Discontent::Post.where(:project_id => @project.id, status: 0).collect {|d| [ d, d.content.similar(params[name_of_model_for_param][:content])]}
    #   r.sort_by!(&:last)
    # end

    # if r.nil? or  r.empty? or  r.last[1] < 40
    if @flash.nil? or @flash.empty?
     @post = @project.discontents.create(params[name_of_model_for_param])
     user_for_post = params[:select_for_clubers].present? ? User.find(params[:select_for_clubers]) : current_user
     @post.user = user_for_post
     @post.save
     user_for_post.journals.build(:type_event=>name_of_model_for_param+"_save", :project => @project, :body=>"#{@post.content}:#{@post.id}").save!
     user_for_post.add_score(:type => :add_discontent_post)
     if !params[:discontent_post_aspects].nil? and @posts.nil? and (@flash.nil? or @flash.empty?)
       params[:discontent_post_aspects].each do |asp|
         aspect = Discontent::PostAspect.create(post_id: @post.id, aspect_id: asp.to_i)
         aspect.save!
       end
     end
    end
    # redirect_to  :action=>'show', :id => @post.id, :project => @project
    #return
    # else
    #   @posts = r.collect {|d| d[0] if d[1]> 40}.compact.reverse
    # end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @post = current_model.find(params[:id])
    @project = Core::Project.find(params[:project])
    unless params[:discontent_post_aspects].nil?
      @post.update_status_fields(params[name_of_model_for_param])
      @post.update_attributes(params[name_of_model_for_param])

      @post.update_post_aspects(params[:discontent_post_aspects])

      current_user.journals.build(:type_event=>name_of_model_for_param+"_update", :project => @project, :body=>"#{@post.content[0..12]}:#{@post.id}").save!
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

   def union_discontent
     @project = Core::Project.find(params[:project])
     @post = Discontent::Post.find(params[:id])
     @new_post =Discontent::Post.create(status: 2, style: @post.style, project: @project, content: params[:union_post_descr], whered: @post.whered, whend: @post.whend)
     @new_post.save!
     unless params[:posts].nil?
       params[:posts].each do |p|
         post = Discontent::Post.find(p)
         post.update_attributes(status: 1, discontent_post_id: @new_post.id)
         @new_post.update_union_post_aspects(post.post_aspects)
       end
     end
     @post.update_attributes(status: 1, discontent_post_id: @new_post.id)
     @new_post.update_union_post_aspects(@post.post_aspects)
     redirect_to discontent_posts_path(@project)
   end

   def unions
     @project = Core::Project.find(params[:project])

     @posts  = current_model.where(:project_id => @project)
     .where(status: 2)
     .order_by_param(@order)
     .paginate(:page => params[:page], :per_page => 40)
     #.where('aspect_id  IN (?) ' , current_user.aspects(@project.id).collect(&:id))
     respond_to do |format|
       format.js
     end
   end

   def remove_union
     @project = Core::Project.find(params[:project])
     @post = Discontent::Post.find(params[:id])
     @union_post = Discontent::Post.find(params[:post_id])
     if @post.one_last_post? and boss?
         @union_post.update_attributes(status: 0, discontent_post_id: nil)
         @post.destroy
         @post.discontent_post_aspects.destroy_all
         redirect_to action: "index"
         return
     else
       @union_post.update_attributes(status: 0, discontent_post_id: nil)
       @post.destroy_ungroup_aspects(@union_post)
       respond_to do |format|
         format.js
       end
     end
   end

   def ungroup_union
     @project = Core::Project.find(params[:project])
     @post = Discontent::Post.find(params[:id])
     unless @post.discontent_posts.nil?
       @post.discontent_posts.each do |post|
         post.update_attributes(status: 0, discontent_post_id: nil)
       end
     end
     if boss?
       @post.destroy
       @post.discontent_post_aspects.destroy_all
     end
     redirect_to action: "index"
     #respond_to do |format|
     #  format.js {render :js => "alert('Разгруппировано');"}
     #end
   end

   def add_union
     @project = Core::Project.find(params[:project])
     @post = Discontent::Post.find(params[:id])
     @union_post = Discontent::Post.find(params[:post_id])
     @union_post.update_attributes(status: 1, discontent_post_id: @post.id)
     @post.update_union_post_aspects(@union_post.post_aspects)
     respond_to do |format|
       format.js
     end
   end

    def status_post
      @project = Core::Project.find(params[:project])
      @post = Discontent::Post.find(params[:id])
      @type = params[:type_field]
      if @post.post_notes(@type.to_i).size == 0
        @post.update_attributes(view_context.column_for_type_field(@type.to_i) => 't')
      end
      respond_to do |format|
        format.js
      end
    end
    def new_note
      @project = Core::Project.find(params[:project])
      @post = Discontent::Post.find(params[:id])
      @type = params[:type_field]
      @post_note = Discontent::Note.new
      respond_to do |format|
        format.js
      end
    end
    def create_note
      @project = Core::Project.find(params[:project])
      @post = Discontent::Post.find(params[:id])
      @post_note = Discontent::Note.create(params[:discontent_note])
      @post_note.post_id = params[:id]
      @post_note.type_field = params[:type_field]
      @post_note.user_id = current_user.id
      @type = params[:type_field]
      current_user.journals.build(:type_event=>'my_discontent_note', :user_informed => @post.user, :project => @project, :body=>"#{@post_note.content[0..24]}:#{@post.id}", :viewed=> false).save!

      if @post.post_notes(@type.to_i).size == 0
        @post.update_attributes(view_context.column_for_type_field(@type.to_i) => 'f')
      end
      respond_to do |format|
        if @post_note.save
          format.js
        else
          render "new_note"
        end
      end
    end

    def destroy_note
      @project = Core::Project.find(params[:project])
      @post = Discontent::Post.find(params[:id])
      @type = params[:type_field]
      @post_note = Discontent::Note.find(params[:note_id])
      @post_note.destroy if boss?
      respond_to do |format|
        format.js
      end
    end

    def next_post_for_vote
      @project = Core::Project.find(params[:project])
      @post_vote = voting_model.find(params[:id])
      @post_vote.final_votings.create(:user => current_user, :against => params[:against]) unless @post_vote.voted_users.include? current_user
      @votes = current_user.voted_discontent_posts.where(:project_id => @project).count
      @post_all = current_model.where(:project_id => @project, :status => 2).count
      #if @project.get_united_posts_for_vote(current_user).empty?
      #  redirect_to action: "index"
      #end
    end

    def set_required
      @post = Discontent::Post.find(params[:id])
      @post.update_attributes(:status => 4) if boss?
    end

    def fast_discussion_discontents
      @project = Core::Project.find(params[:project])
      status  = @project.status == 3 ? 0 : 2
      @aspects = Discontent::Aspect.where(:project_id => @project, :status => 0).order(:id)
      @users_rc = User.where(admin:false, type_user: 4)
      @discontent_aspect = Discontent::Aspect.find(params[:asp_id]) unless params[:asp_id].nil?
      @discontent_post = Discontent::Post.find(params[:dis_id]) unless params[:dis_id].nil?
      @select_aspect = Discontent::Aspect.find(params[:aspect_id]) unless params[:aspect_id].nil?

      user_discussion_posts = current_user.user_discussion_disposts.where(:project_id => @project).select('distinct "discontent_posts".*').pluck(:id)

      if params[:asp_id].nil? and params[:dis_id].nil? and params[:aspect_id].nil? and params[:save_form_dispost].nil?
        @aspects.each do |asp|
          @aspect = asp
          posts_for_discussion = @aspect.aspect_posts.posts_for_discussions(@project).by_status(status).by_discussions(user_discussion_posts).order('"discontent_posts"."id"')
          unless posts_for_discussion.empty?
            @post = posts_for_discussion.first
            break
          end
        end
      elsif !params[:aspect_id].nil?
        @aspect = @select_aspect
        @post = @aspect.aspect_posts.posts_for_discussions(@project).by_status(status).by_discussions(user_discussion_posts).order('"discontent_posts"."id"').first
      elsif !params[:dis_id].nil? and !params[:asp_id].nil?
        index = @aspects.index @discontent_aspect
        @able = true
        able_save = 0
        while @able do
          @aspect = @aspects[index]
          @posts_for_discussion = @aspect.aspect_posts.posts_for_discussions(@project).by_status(status).by_discussions(user_discussion_posts).select('distinct "discontent_posts".*').order('"discontent_posts"."id"')
          unless @posts_for_discussion.empty?
            @posts_for_discussion.each do |p|
              @post = p
              if (@aspect == @discontent_aspect and @post.id > @discontent_post.id) or (@aspect != @discontent_aspect and @post.id > 0) or @post == @posts_for_discussion.last
                if params[:empty_discussion]
                  @able = false if @post != @posts_for_discussion.last or (@posts_for_discussion.size == 1 and @aspect != @discontent_aspect) or (@aspect == @discontent_aspect and @post.id > @discontent_post.id)
                  break
                elsif params[:save_form]
                  if !params[:discussion].empty?  and not (@aspect != @discontent_aspect and @post == @discontent_post) and able_save == 0
                    @comment = @discontent_post.comments.create(:content => params[:discussion], :user => current_user)
                    able_save += 1
                    current_user.journals.build(:type_event=>'discontent_comment'+'_save', :project => @project, :body=>"#{@comment.content[0..48]}:#{@discontent_post.id}#comment_#{@comment.id}").save!
                    if @post.user!=current_user
                      current_user.journals.build(:type_event=>'my_'+'discontent_comment', :user_informed => @discontent_post.user, :project => @project, :body=>"#{@comment.content[0..24]}:#{@discontent_post.id}#comment_#{@comment.id}", :viewed=> false).save!
                    end
                    current_user.discontent_post_discussions.create(post: @discontent_post, aspect: @discontent_aspect)
                  end
                  @able = false if @post != @posts_for_discussion.last or (@posts_for_discussion.size == 1 and @aspect != @discontent_aspect) or (@aspect == @discontent_aspect and @post.id > @discontent_post.id)
                  break
                else
                  next
                end
              end
            end
          end
          index+=1
          @able = false if index == @aspects.size
        end
      elsif !params[:save_form_dispost].nil?
        if !params[:discontent_post][:content].empty? and !params[:discontent_post][:whered].empty? and !params[:discontent_post][:whend].empty? and !params[:discontent_post][:style].empty?
          @dispost = @project.discontents.create(params[:discontent_post])
          user_for_post = params[:select_for_clubers].present? ? User.find(params[:select_for_clubers]) : current_user
          @dispost.user = user_for_post
          @dispost.save!
          user_for_post.journals.build(:type_event=>'discontent_post'+"_save", :project => @project, :body=>"#{@dispost.content}:#{@dispost.id}").save!
          user_for_post.add_score(:type => :add_discontent_post)
          unless params[:select_for_discussion_aspects_add].nil?
            asp = params[:select_for_discussion_aspects_add]
            Discontent::PostAspect.create(post_id: @dispost.id, aspect_id: asp.to_i)
          end
        end
      end

      respond_to do |format|
        format.js
      end
    end

end
