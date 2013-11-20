# encoding: utf-8

class Plan::PostsController < PostsController

  layout 'life_tape/posts2', :only => [:new, :edit, :show]

  def current_model
    Plan::Post
  end 
  def comment_model
    Plan::Comment
  end

  def note_model
    Plan::PostNote
  end

  def voting_model  
    Plan::Post
  end

  def prepare_data
    @project = Core::Project.find(params[:project]) 
    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.first  
    @status = params[:status]
    @aspects = Discontent::Aspect.where(:project_id => @project)

  end


  def index
    @posts = current_model.where(:project_id => @project, :status => @status).paginate(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def create
    @project = Core::Project.find(params[:project])
    @plan_post = Plan::Post.new(params[:plan_post])
    @plan_post.number_views =0
    @plan_post.project = @project
    @plan_post.user = current_user
    @plan_post.status = 0
    @plan_post.step= @plan_post.step+1
    @plan_post.goal = params[:plan_post][:goal]

    #unless params['correct_disc'].nil?
    #  params['correct_disc'].each do |asp|
    #    asp[1].each do |v|
    #      if v!= ''
    #        unless Discontent::Post.exists?(v[0])
    #          disc = Discontent::Post.new(v[1]['disc'])
    #          disc.status = 5
    #          disc.project = @project
    #          disc.user = current_user
    #          disc.save!
    #          v[1].delete :disc
    #          @plan_post.post_aspects.build(v[1].merge(:discontent_aspect_id=> disc.id,:first_stage => (asp[0]=='accordion_concept1' ? 1 : 0)))
    #        else
    #          v[1].delete :disc
    #          @plan_post.post_aspects.build(v[1].merge(:discontent_aspect_id=> v[0],:first_stage => (asp[0]=='accordion_concept1' ? 1 : 0)))
    #        end
    #
    #      end
    #    end
    #
    #  end
    #end


    respond_to do |format|
      if @plan_post.save!
         current_user.journals.build(:type_event=>'plan_post_save', :body=>@plan_post.id).save!
        format.html { redirect_to   edit_plan_post_path(project: @project, id: @plan_post), notice: 'Пройден первый шаг!' }
        format.json { render json: @plan_post, status: :created, location: @plan_post }
      else
        format.html { render action: 'new' }
        format.json { render json: @plan_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /Plan/posts/1
  # PUT /Plan/posts/1.json
  def update
    @project = Core::Project.find(params[:project])
    @plan_post = Plan::Post.find(params[:id])

    if @plan_post.step == 2
      @plan_post.post_aspects.destroy_all
      unless params['post_aspects'].nil?
        params['post_aspects'].each do |k,v|
          if k!= ''
            dis = Discontent::Post.find(k)
            pa = Plan::PostAspect.new(v)
            pa.discontent = dis
            @plan_post.post_aspects << pa
          end
        end
      end
    end

    @plan_post.step = @plan_post.step + 1
    respond_to do |format|
        @plan_post.save
        current_user.journals.build(:type_event=>'plan_post_update', :body=>@plan_post.id).save!
        format.html { redirect_to edit_plan_post_path(project: @project, id: @plan_post), notice: "Шаг № #{@plan_post.step - 1 }  успешно пройден" }
      end

  end

 def add_aspect
   @id=params[:id]
   @discontent = Discontent::Post.find(@id)
   @cond = params[:cond_id]
   unless params[:cond_id].nil?
    @cond = Concept::PostAspect.find(@cond)
   end

   respond_to do |format|
     format.html # new.html.erb
     format.js
   end
 end

 def add_new_discontent
   @discontent = Discontent::Post.new
   @discontent.id = (0..10).map{rand(0..10)}.join
   @aspects = Discontent::Aspect.where(:project_id =>params[:project])
   if params[:plan_stage]
     @div_for_aspects = 'accordion_concept2'
   else
     @div_for_aspects = 'accordion_concept1'
   end
   respond_to do |format|
     format.js
   end

 end

end
