# encoding: utf-8

class Estimate::PostsController < PostsController


  #layout 'life_tape/posts2', :only => [:new, :edit, :show]
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
    Plan::Post
  end


  def prepare_data
    @project = Core::Project.find(params[:project])
    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.first
    @my_jounals = Journal.count_events_for_my_feed(@project.id, current_user)
    @mini_help = Help::Post.where(stage:4, mini: true).first

    @status = params[:status]
    @aspects = Discontent::Aspect.where(:project_id => @project)
    add_breadcrumb I18n.t('stages.estimate'), estimate_posts_path(@project)

  end


  def index
    if @project.status == 11
      #puts  current_user.plan_post_votings
      @number_v = @project.stage5 - current_user.plan_post_votings.size
      @votes = @project.stage5
      if boss?
        @all_people = @project.users.size

        @voted_people = ActiveRecord::Base.connection.execute("select count(*) as r from (select distinct v.user_id from plan_votings v  left join   plan_posts asp on (v.plan_post_id = asp.id) ) as dm").first["r"]
        @votes = ActiveRecord::Base.connection.execute("select count(*) as r from (select  v.user_id from plan_votings v  left join   plan_posts asp on (v.plan_post_id = asp.id) ) as dm").first["r"].to_i
      end
    end
    @posts = Plan::Post.where(:project_id => @project, :status => 0).paginate(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end


  def edit
    @post = Estimate::Post.find(params[:id])
    @plan_post = @post.post
    @pair_estimates1 = {}
    @plan_post.post_first_conds.each do |p|
      @pair_estimates1[p] = @post.post_aspects.by_plan_fc(p.id).first
    end

    @pair_estimates2 = {}
    @plan_post.post_aspects.each do |p|
      @pair_estimates2[p] = @post.post_aspects.by_plan_pa(p.id).first
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
      format.html {render :layout => 'application_two_column'}
    end
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
      @estimate_post.status = 1
    end
    #puts "__________", @estimate_post.status
    @estimate_post.post_aspects=[]
    if not jury?

        plan_post.post_aspects.each do |tr|
          est_tr = Estimate::PostAspect.new
          est_tr.first_stage = false
          est_tr.plan_post_aspect = tr
          op = params[:op]['0'][tr.id.to_s]
          est_tr.op1 = op['1']
          est_tr.op2 = op['2']
          est_tr.op3 = op['3']
          est_tr.op4 = op['4']
          est_tr.op = params[:op_text]['0'][tr.id.to_s]

          ozf = params[:ozf]['0'][tr.id.to_s]
          est_tr.ozf1 = ozf['1']
          est_tr.ozf2 = ozf['2']
          est_tr.ozf3 = ozf['3']
          est_tr.ozf4 = ozf['4']
          est_tr.ozf = params[:ozf_text]['0'][tr.id.to_s]

          ozs = params[:ozs]['0'][tr.id.to_s]
          est_tr.ozs1 = ozs['1']
          est_tr.ozs2 = ozs['2']
          est_tr.ozs3 = ozs['3']
          est_tr.ozs4 = ozs['4']
          est_tr.ozs = params[:ozs_text]['0'][tr.id.to_s]

          on = params[:on]['0'][tr.id.to_s]
          est_tr.on1 = on['1']
          est_tr.on2 = on['2']
          est_tr.on3 = on['3']
          est_tr.on4 = on['4']
          est_tr.on = params[:on_text]['0'][tr.id.to_s]
          @estimate_post.post_aspects << est_tr
        end

      plan_post.post_first_conds.each do |tr|
          est_tr = Estimate::PostAspect.new
          est_tr.first_stage = true
          est_tr.plan_post_first_cond = tr
          op = params[:op]['1'][tr.id.to_s]
          est_tr.op1 = op['1']
          est_tr.op2 = op['2']
          est_tr.op3 = op['3']
          est_tr.op4 = op['4']
          est_tr.op = params[:op_text]['1'][tr.id.to_s]

          ozf = params[:ozf]['1'][tr.id.to_s]
          est_tr.ozf1 = ozf['1']
          est_tr.ozf2 = ozf['2']
          est_tr.ozf3 = ozf['3']
          est_tr.ozf4 = ozf['4']
          est_tr.ozf = params[:ozf_text]['1'][tr.id.to_s]

          ozs = params[:ozs]['1'][tr.id.to_s]
          est_tr.ozs1 = ozs['1']
          est_tr.ozs2 = ozs['2']
          est_tr.ozs3 = ozs['3']
          est_tr.ozs4 = ozs['4']
          est_tr.ozs = params[:ozs_text]['1'][tr.id.to_s]

          on = params[:on]['1'][tr.id.to_s]
          est_tr.on1 = on['1']
          est_tr.on2 = on['2']
          est_tr.on3 = on['3']
          est_tr.on4 = on['4']
          est_tr.on = params[:on_text]['1'][tr.id.to_s]
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
    @project = Core::Project.find(params[:project])
    plan_post = Plan::Post.find(params[:post_id])
    @estimate_post.post_aspects=[]
      plan_post.post_aspects.each do |tr|
        est_tr = Estimate::PostAspect.new
        est_tr.first_stage = false
        est_tr.plan_post_aspect = tr
        op = params[:op]['0'][tr.id.to_s]
        est_tr.op1 = op['1']
        est_tr.op2 = op['2']
        est_tr.op3 = op['3']
        est_tr.op4 = op['4']
        est_tr.op = params[:op_text]['0'][tr.id.to_s]

        ozf = params[:ozf]['0'][tr.id.to_s]
        est_tr.ozf1 = ozf['1']
        est_tr.ozf2 = ozf['2']
        est_tr.ozf3 = ozf['3']
        est_tr.ozf4 = ozf['4']
        est_tr.ozf = params[:ozf_text]['0'][tr.id.to_s]

        ozs = params[:ozs]['0'][tr.id.to_s]
        est_tr.ozs1 = ozs['1']
        est_tr.ozs2 = ozs['2']
        est_tr.ozs3 = ozs['3']
        est_tr.ozs4 = ozs['4']
        est_tr.ozs = params[:ozs_text]['0'][tr.id.to_s]

        on = params[:on]['0'][tr.id.to_s]
        est_tr.on1 = on['1']
        est_tr.on2 = on['2']
        est_tr.on3 = on['3']
        est_tr.on4 = on['4']
        est_tr.on = params[:on_text]['0'][tr.id.to_s]
        @estimate_post.post_aspects << est_tr
      end

      plan_post.post_first_conds.each do |tr|
        est_tr = Estimate::PostAspect.new
        est_tr.first_stage = true
        est_tr.plan_post_first_cond = tr
        op = params[:op]['1'][tr.id.to_s]
        est_tr.op1 = op['1']
        est_tr.op2 = op['2']
        est_tr.op3 = op['3']
        est_tr.op4 = op['4']
        est_tr.op = params[:op_text]['1'][tr.id.to_s]

        ozf = params[:ozf]['1'][tr.id.to_s]
        est_tr.ozf1 = ozf['1']
        est_tr.ozf2 = ozf['2']
        est_tr.ozf3 = ozf['3']
        est_tr.ozf4 = ozf['4']
        est_tr.ozf = params[:ozf_text]['1'][tr.id.to_s]

        ozs = params[:ozs]['1'][tr.id.to_s]
        est_tr.ozs1 = ozs['1']
        est_tr.ozs2 = ozs['2']
        est_tr.ozs3 = ozs['3']
        est_tr.ozs4 = ozs['4']
        est_tr.ozs = params[:ozs_text]['1'][tr.id.to_s]

        on = params[:on]['1'][tr.id.to_s]
        est_tr.on1 = on['1']
        est_tr.on2 = on['2']
        est_tr.on3 = on['3']
        est_tr.on4 = on['4']
        est_tr.on = params[:on_text]['1'][tr.id.to_s]
        @estimate_post.post_aspects << est_tr
      end

    @estimate_post.save
    @estimate_post.update_attributes(params[:estimate_post])
    current_user.journals.build(:type_event=>'estimate_post_update', :body=>@estimate_post.id).save!

    redirect_to estimate_post_path(@project,@estimate_post), notice: 'Оценка успешно обновлена.'

end

  
end
