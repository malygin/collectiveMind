class Estimate::PostsController < PostsController
  # def note_model
  #   Estimate::PostNote
  # end

  def voting_model
    Plan::Post
  end

  def prepare_data
    # @status = params[:status]
    # @aspects = Core::Aspect::Post.where(project_id: @project)
    # @vote_all = Plan::Voting.where(plan_votings: {plan_post_id: @project.plan_post.pluck(:id)}).uniq_user.count if @project.status == 11
  end

  def index
    @posts = Plan::Post.where(project_id: @project, status: 0)
  end

  def show
    @post = Estimate::Post.find(params[:id])
    @plan_post = @post.post
    @est_stat = @plan_post.estimate_status.nil? ? 0 : @plan_post.estimate_status
    @comment = comment_model.new
    @comments = @post.comments.paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @post = Estimate::Post.find(params[:id])
    @plan_post = @post.post
    @est_stat = @plan_post.estimate_status.nil? ? 0 : @plan_post.estimate_status
    @pair_estimates1 = {}
    @plan_post.post_aspects.where("post_stage_id = ?", @plan_post.first_stage).each do |p|
      @pair_estimates1[p] = @post.post_aspects.by_plan_pa(p.id).first if p.plan_post_stage.status == 0
    end

    @pair_estimates2 = {}
    @plan_post.post_aspects.where("post_stage_id != ?", @plan_post.first_stage).each do |p|
      @pair_estimates2[p] = @post.post_aspects.by_plan_pa(p.id).first if p.plan_post_stage.status == 0
    end
    respond_to do |format|
      format.html
    end
  end

  def new
    @post = current_model.new
    if params[:plan_id]
      @plan_post = Plan::Post.find(params[:plan_id])
      @est_stat = @plan_post.estimate_status.nil? ? 0 : @plan_post.estimate_status

      @pair_estimates1 = {}
      @plan_post.post_aspects.where("post_stage_id = ?", @plan_post.first_stage).each do |p|
        @pair_estimates1[p] = Estimate::PostAspect.new if p.plan_post_stage.status == 0
      end

      @pair_estimates2 = {}
      @plan_post.post_aspects.where("post_stage_id != ?", @plan_post.first_stage).each do |p|
        @pair_estimates2[p] = Estimate::PostAspect.new if p.plan_post_stage.status == 0
      end
    else
      @plan_posts = Plan::Post.where(project_id: @project, status: 0)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @estimate_post = Estimate::Post.new estimate_post_params

    plan_post = Plan::Post.find(params[:post_id])
    @estimate_post.post = plan_post
    @estimate_post.project = @project
    @estimate_post.user = current_user
    if expert? or admin?
      @estimate_post.status = 0
    elsif jury?
      @estimate_post.status = 3
    else
      @estimate_post.status = 0
    end
    @est_stat = plan_post.estimate_status.nil? ? 0 : plan_post.estimate_status
    @estimate_post.post_aspects=[]
    unless jury?
      if @est_stat == 0
        plan_post.post_aspects.each do |tr|
          if tr.plan_post_stage.status == 0
            est_tr = Estimate::PostAspect.new
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
        end
      else
        plan_post.post_aspects.each do |tr|
          if tr.plan_post_stage.status == 0
            est_tr = Estimate::PostAspect.new
            est_tr.plan_post_aspect = tr
            op = params[:op] ? (params[:op]['0'][tr.id.to_s] ? params[:op]['0'][tr.id.to_s] : 0) : 0
            est_tr.op1 = op
            est_tr.op = params[:op_text]['0'][tr.id.to_s]

            ozf = params[:ozf] ? (params[:ozf]['0'][tr.id.to_s] ? params[:ozf]['0'][tr.id.to_s] : 0) : 0
            est_tr.ozf1 = ozf
            est_tr.ozf = params[:ozf_text]['0'][tr.id.to_s]

            ozs = params[:ozs] ? (params[:ozs]['0'][tr.id.to_s] ? params[:ozs]['0'][tr.id.to_s] : 0) : 0
            est_tr.ozs1 = ozs
            est_tr.ozs = params[:ozs_text]['0'][tr.id.to_s]

            on = params[:on] ? (params[:on]['0'][tr.id.to_s] ? params[:on]['0'][tr.id.to_s] : 0) : 0
            est_tr.on1 = on
            est_tr.on = params[:on_text]['0'][tr.id.to_s]
            @estimate_post.post_aspects << est_tr
          end
        end
      end

    end
    respond_to do |format|
      if @estimate_post.save
        current_user.journals.build(project_id: @project.id, type_event: 'estimate_post_save', body: @estimate_post.id).save!
        format.html { redirect_to action: "index" }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @estimate_post = Estimate::Post.find(params[:id])
    plan_post = Plan::Post.find(params[:post_id])
    @estimate_post.post_aspects.destroy_all
    @est_stat = plan_post.estimate_status.nil? ? 0 : plan_post.estimate_status
    if @est_stat == 0
      plan_post.post_aspects.each do |tr|
        if tr.plan_post_stage.status == 0
          est_tr = Estimate::PostAspect.new
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
      end
    else
      plan_post.post_aspects.each do |tr|
        if tr.plan_post_stage.status == 0
          est_tr = Estimate::PostAspect.new
          est_tr.plan_post_aspect = tr
          op = params[:op] ? (params[:op]['0'][tr.id.to_s] ? params[:op]['0'][tr.id.to_s] : 0) : 0
          est_tr.op1 = op
          est_tr.op = params[:op_text]['0'][tr.id.to_s]

          ozf = params[:ozf] ? (params[:ozf]['0'][tr.id.to_s] ? params[:ozf]['0'][tr.id.to_s] : 0) : 0
          est_tr.ozf1 = ozf
          est_tr.ozf = params[:ozf_text]['0'][tr.id.to_s]

          ozs = params[:ozs] ? (params[:ozs]['0'][tr.id.to_s] ? params[:ozs]['0'][tr.id.to_s] : 0) : 0
          est_tr.ozs1 = ozs
          est_tr.ozs = params[:ozs_text]['0'][tr.id.to_s]

          on = params[:on] ? (params[:on]['0'][tr.id.to_s] ? params[:on]['0'][tr.id.to_s] : 0) : 0
          est_tr.on1 = on
          est_tr.on = params[:on_text]['0'][tr.id.to_s]
          @estimate_post.post_aspects << est_tr
        end
      end
    end

    @estimate_post.save
    @estimate_post.update_attributes estimate_post_params
    current_user.journals.build(project_id: @project.id, type_event: 'estimate_post_update', body: @estimate_post.id).save!
    redirect_to estimate_post_path(@project, @estimate_post), notice: 'Оценка успешно обновлена.'
  end

  private
  def estimate_post_params
    params.require(:estimate_post).permit(:post_id, :content, :oppsh1, :oppsh2, :oppsh3, :oppsh, :ozpshf1, :ozpshf2, :ozpshf3,
                                          :ozpshf, :ozpshs1, :ozpshs2, :ozpshs3, :ozpshs, :onpsh1, :onpsh2, :onpsh3, :onpsh,
                                          :nepr1, :nepr2, :nepr3, :nepr4, :nepr, :status, :project_id, :imp, :nep1, :nep2,
                                          :nep3, :nep4, :nep, :all_grade, :number_views, :censored, :useful, :approve_status)
  end
end
