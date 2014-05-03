# encoding: utf-8

class Concept::PostsController < PostsController
  # GET /discontent/posts
  # GET /discontent/posts.json
   layout 'application_two_column', :only => [:new, :edit, :show]
   autocomplete :concept_post, :resource, :class_name => 'Concept::Post' , :full => true

   def current_model
    Concept::Post
  end
  
  def comment_model
    Concept::Comment
  end

  def note_model
    Concept::PostNote
  end

  def voting_model  
    Concept::PostAspect
  end

   def autocomplete_concept_post_resource
     pr=Set.new
     pr.merge(Concept::Resource.where(:project_id => params[:project]).map {|d| {:value => d.name}})
     #if params[:term].length > 1
     #  pr.merge(Discontent::Post.select("DISTINCT whend as value").where("LOWER(whend) like LOWER(?)", "%#{params[:term]}%")
     #           .where(:project_id => params[:project]).map {|d| {:value => d.value } })
     #end
     render json: pr
   end


   def prepare_data
    @project = Core::Project.find(params[:project])
    @aspects = Discontent::Aspect.where(:project_id => @project, :status => 0)
    add_breadcrumb I18n.t('stages.concept'), concept_posts_path(@project)
    @mini_help = Help::Post.where(stage:3, mini: true).first

    @my_jounals = Journal.count_events_for_my_feed(@project.id, current_user)


    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.first  
    @status = 4
  end


  def index
    @posts = current_model.where(:project_id => @project, :status => @status).paginate(:page => params[:page])

      if @project.status == 8
        @number_v = @project.stage3 - current_user.concept_post_votings.size
        @votes = @project.stage3
        @path_for_voting = "/project/#{@project.id}/concept/vote/"

        if boss?
          @all_people = @project.users.size

          @voted_people = ActiveRecord::Base.connection.execute("select count(*) as r from (select distinct v.user_id from concept_votings v  left join   concept_post_aspects asp on (v.concept_post_aspect_id = asp.id) ) as dm").first["r"]
          @votes = ActiveRecord::Base.connection.execute("select count(*) as r from (select  v.user_id from concept_votings v  left join   concept_post_aspects asp on (v.concept_post_aspect_id = asp.id) ) as dm").first["r"].to_i
        end
      end

    render 'index' , :layout => 'application_two_column'
  end

  def create
    @project = Core::Project.find(params[:project])
    @concept_post = Concept::Post.new
    params[:pa].each do |pa|
      post_aspect = Concept::PostAspect.new(pa[1])
      disc = Discontent::Post.find(pa[0])
      post_aspect.discontent = disc
      @concept_post.post_aspects << post_aspect
    end
    @concept_post.number_views =0
    @concept_post.user = current_user
    @concept_post.status = 0
    @concept_post.project = @project
    unless params[:resor].nil?
      params[:resor].each_with_index do |r,i|
        @concept_post.concept_post_resources.build(:name => r, :desc => params[:res][i])
      end
    end
    #unless params['correct_disc'].nil?
    #  params['correct_disc'].each do |v|
    #    if v!= ''
    #      unless Discontent::Post.exists?(v[0])
    #        disc =new_disc(v[1])
    #        v[1].delete :disc
    #        @concept_post.post_aspects.build(v[1].merge :discontent_aspect_id=> disc.id)
    #      else
    #        v[1].delete :disc
    #        @concept_post.post_aspects.build(v[1].merge :discontent_aspect_id=> v[0])
    #      end
    #
    #    end
    #  end
    #end
    #
   respond_to do |format|
      if @concept_post.save!
        unless params[:cd].nil?
          params[:cd].each do |cd|
            Concept::PostDiscontent.create(post_id: @concept_post.id, discontent_post_id: cd.to_i)
          end
        end
        current_user.journals.build(:type_event=>'concept_post_save', :body=>@concept_post.id,  :project => @project).save!
        format.html { redirect_to  action: "index"  }
        format.json { render json: @concept_post, status: :created, location: @concept_post }
      else
        format.html { render action: "new" }
        format.json { render json: @concept_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /concept/posts/1
  # PUT /concept/posts/1.json
  def update
    @project = Core::Project.find(params[:project])

    @concept_post = Concept::Post.find(params[:id])
    #@concept_post.update_attributes(params[:concept_post])
    @concept_post.post_aspects.destroy_all

    params[:pa].each do |pa|
      post_aspect = Concept::PostAspect.new(pa[1])
      disc = Discontent::Post.find(pa[0])
      post_aspect.discontent = disc
      @concept_post.post_aspects << post_aspect
    end
    @concept_post.concept_post_resources.destroy_all
    unless params[:resor].nil?
      params[:resor].each_with_index do |r,i|
        @concept_post.concept_post_resources.build(:name => r, :desc => params[:res][i])
      end
    end

    #unless params['correct_disc'].nil?
    #  params['correct_disc'].each do |v|
    #    if v!= ''
    #      unless Discontent::Post.exists?(v[0])
    #        disc =new_disc(v[1])
    #        v[1].delete :disc
    #        @concept_post.post_aspects.build(v[1].merge :discontent_aspect_id=> disc.id)
    #      else
    #        @concept_post.post_aspects.build(v[1].merge :discontent_aspect_id=> v[0])
    #      end
    #
    #    end
    #  end
    #end

    respond_to do |format|
      if @concept_post.save!
        @concept_post.concept_post_discontents.destroy_all
        params[:cd].each do |cd|
          Concept::PostDiscontent.create(post_id: @concept_post.id, discontent_post_id: cd.to_i)
        end
        current_user.journals.build(:type_event=>'concept_post_update', :body=>@concept_post.id,  :project => @project).save!

        format.html { redirect_to action: "show", :project => @project, :id => @concept_post.id }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @concept_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def vote_list
    @posts = current_model.where(:project_id => @project, :status => 2)
    # i have votes now
    @number_v = @project.stage3 - current_user.voted_concept_posts.count
    @path_for_voting = "/project/#{@project.id}/concept/vote/"
    #all number of votes
    @votes = @project.stage3
  end

  def new
    @post = current_model.new
    @discontent_post = Discontent::Post.find(params[:dis_id])
    @resources = Concept::Resource.where(:project_id => @project.id)
    #@aspects = Discontent::Aspect.where(:project_id => @project)
    @pa =Concept::PostAspect.new
    respond_to do |format|
      format.html { render :layout => 'application_two_column' }
      format.json { render json: @post }
    end
  end

   def edit
     @post = current_model.find(params[:id])
     @pa =@post.post_aspects.first

     @discontent_post =@pa.discontent
     #@aspects = Discontent::Aspect.where(:project_id => @project)

   end

  def add_aspect
    
    @aspect = Discontent::Aspect.find(params[:aspect_id]) 
    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

   def add_new_discontent
     @discontent = Discontent::Post.new
     @discontent.id = (0..10).map{rand(0..10)}.join
     @aspects = Discontent::Aspect.where(:project_id =>params[:project])
     respond_to do |format|
       format.js
     end

   end

   def expert_acceptance_save
     post = save_note(params, 2, 'Принято!',name_of_model_for_param+'_acceptance' )
     post.user.add_score(200*post.post_aspects.size)
     redirect_to  action: "index"
   end
  #write fact of voting in db

   def status_post
     @project = Core::Project.find(params[:project])
     @post = Concept::Post.find(params[:id])
     @type = params[:type_field]
     if @post.post_notes(@type.to_i).size == 0
        @post.update_attributes(column_for_concept_type(@type.to_i) => 't')
     end
     respond_to do |format|
       format.js
     end
   end
   def new_note
     @project = Core::Project.find(params[:project])
     @post = Concept::Post.find(params[:id])
     @type = params[:type_field]
     @post_note = Concept::Note.new
     respond_to do |format|
       format.js
     end
   end
   def create_note
     @project = Core::Project.find(params[:project])
     @post = Concept::Post.find(params[:id])
     @post_note = Concept::Note.create(params[:concept_note])
     @post_note.post_id = params[:id]
     @post_note.type_field = params[:type_field]
     @post_note.user_id = current_user.id
     @type = params[:type_field]
     if @post.post_notes(@type.to_i).size == 0
       @post.update_attributes(column_for_concept_type(@type.to_i) => 'f')
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
     @post = Concept::Post.find(params[:id])
     @type = params[:type_field]
     @post_note = Concept::Note.find(params[:note_id])
     @post_note.destroy if boss?
     respond_to do |format|
       format.js
     end
   end

   def add_dispost
     @project = Core::Project.find(params[:project])
     @dispost = Discontent::Post.find(params[:dispost_id])
     @remove_able = params[:remove_able]
     respond_to do |format|
       format.js
     end
   end


  private
  def new_disc(param)
    disc = Discontent::Post.new(param['disc'])
    disc.status = 5
    project = Core::Project.find(params[:project])

    disc.project = project
    disc.user = current_user
    disc.save!
    disc
  end
  
end
