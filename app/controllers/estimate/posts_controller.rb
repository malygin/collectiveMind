# encoding: utf-8

class Estimate::PostsController < PostsController


  layout 'life_tape/posts2', :only => [:new, :edit, :show]
  def current_model
    Estimate::Post
  end
  def comment_model
    Estimate::Comment
  end

  def note_model
    Estimate::PostNote
  end

  def voting_model
    Estimate::Post
  end

  def index
    @posts = Plan::Post.where(:project_id => @project, :status => 2).paginate(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end
  def new
    @post = current_model.new
    @plan_post = Plan::Post.find(params[:plan_id])


    @pair_estimates1 = {}
    @plan_post.post_first_conds.each do |p|
      @pair_estimates1[p] = Estimate::PostAspect.new
    end

    @pair_estimates2 = {}
    @plan_post.post_aspects.each do |p|
      @pair_estimates2[p] = Estimate::PostAspect.new
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end
  def prepare_data
    @project = Core::Project.find(params[:project])
    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.first
    @status = params[:status]
    @aspects = Discontent::Aspect.where(:project_id => @project)

  end
  def create
    @estimate_post = Estimate::Post.new(params[:estimate_post])
    @project = Core::Project.find(params[:project])

    plan_post = Plan::Post.find(params[:post_id])
    @estimate_post.post = plan_post
    @estimate_post.project = @project
    @estimate_post.user = current_user
    #puts "__________",boss?
    if expert? or admin?
      @estimate_post.status = 1
    elsif jury?
      @estimate_post.status = 3
    else
      @estimate_post.status = 0
    end
    #puts "__________", @estimate_post.status
    @estimate_post.post_aspects=[]
    if not jury?
        plan_post.post_aspects.each do |tr|
          est_tr = Estimate::PostAspect.new
          est_tr.plan_post_aspect = tr
          op = params[:op][tr.id.to_s]
          est_tr.op1 = op['1']
          est_tr.op2 = op['2']
          est_tr.op3 = op['3']
          #est_tr.op = params[:op_text][tr.id.to_s]

          ozf = params[:ozf][tr.id.to_s]
          est_tr.ozf1 = ozf['1']
          est_tr.ozf2 = ozf['2']
          est_tr.ozf3 = ozf['3']
          #est_tr.ozf = params[:ozf_text][tr.id.to_s]

          ozs = params[:ozs][tr.id.to_s]
          est_tr.ozs1 = ozs['1']
          est_tr.ozs2 = ozs['2']
          est_tr.ozs3 = ozs['3']
          est_tr.ozs = params[:ozs_text][tr.id.to_s]

          on = params[:on][tr.id.to_s]
          est_tr.on1 = on['1']
          est_tr.on2 = on['2']
          est_tr.on3 = on['3']
          #est_tr.on = params[:on_text][tr.id.to_s]

          @estimate_post.post_aspects << est_tr

          end
      end



    respond_to do |format|
      if @estimate_post.save
        current_user.journals.build(:type_event=>'estimate_post_save', :body=>@estimate_post.id).save!

        format.html { redirect_to  action: "index" , notice: 'Оценка добавлена' }
        format.json { render json: @estimate_post, status: :created, location: @estimate_post }
      else
        format.html { render action: "new" }
        format.json { render json: @estimate_post.errors, status: :unprocessable_entity }
      end
    end
  end



  # PUT /estimate/posts/1
  # PUT /estimate/posts/1.json
  def update
    @estimate_post = Estimate::Post.find(params[:id])
    @estimate_post.task_triplets.destroy_all
    @estimate_post.task_triplets=[]
    @estimate_post.post.task_triplets.each do |tr|
      est_tr = Estimate::TaskTriplet.new
      est_tr.task_triplet = tr
      op = params[:op][tr.id.to_s]
      est_tr.op1 = op['1']
      est_tr.op2 = op['2']
      est_tr.op3 = op['3']
      est_tr.op = params[:op_text][tr.id.to_s]      

      ozf = params[:ozf][tr.id.to_s]
      est_tr.ozf1 = ozf['1']
      est_tr.ozf2 = ozf['2']
      est_tr.ozf3 = ozf['3']
      est_tr.ozf = params[:ozf_text][tr.id.to_s]

      ozs = params[:ozs][tr.id.to_s]
      est_tr.ozs1 = ozs['1']
      est_tr.ozs2 = ozs['2']
      est_tr.ozs3 = ozs['3']
      est_tr.ozs = params[:ozs_text][tr.id.to_s]

      on = params[:on][tr.id.to_s]
      est_tr.on1 = on['1']
      est_tr.on2 = on['2']
      est_tr.on3 = on['3']
      est_tr.on = params[:on_text][tr.id.to_s]

      @estimate_post.task_triplets << est_tr

    end
    @estimate_post.update_attributes(params[:estimate_post])
    current_user.journals.build(:type_event=>'estimate_post_update', :body=>@estimate_post.id).save!

    redirect_to @estimate_post, notice: 'Оценка успешно обновлена.'

end

  
end
