# encoding: utf-8

class Estimate::PostsController < ApplicationController
  # GET /estimate/posts
  # GET /estimate/posts.json
  def prepare_data

    @journals = Journal.events_for_user_feed
    @news = ExpertNews::Post.first    
  end
  def index
    prepare_data
    @estimate_posts = Estimate::Post.all
    @plan_posts = Plan::Post.where(:status => '3')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @estimate_posts }
    end
  end

  # GET /estimate/posts/1
  # GET /estimate/posts/1.json
  def show
    prepare_data
    @estimate_post = Estimate::Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @estimate_post }
    end
  end

  # GET /estimate/posts/new
  # GET /estimate/posts/new.json
  def new
    prepare_data
    @estimate_post = Estimate::Post.new
    @plan_post = Plan::Post.find(params[:post_id])
    @triplet_estimates = {}
    @plan_post.task_triplets.each do |p|
      @triplet_estimates[p] = Estimate::TaskTriplet.new
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @estimate_post }
    end
  end

  # GET /estimate/posts/1/edit
  def edit
    prepare_data
    @estimate_post = Estimate::Post.find(params[:id])
    @plan_post = @estimate_post.post
    @triplet_estimates = {}
    @plan_post.task_triplets.each do |p|
      @triplet_estimates[p] = @estimate_post.task_triplets.select{|x| x.task_triplet = p }.first
    end

  end

  # POST /estimate/posts
  # POST /estimate/posts.json
  def create
    @estimate_post = Estimate::Post.new(params[:estimate_post])
    plan_post = Plan::Post.find(params[:post_id])
    @estimate_post.post = plan_post
    @estimate_post.user = current_user
    #puts "__________",boss?
    if expert? or admin?
      @estimate_post.status = 1
    else
      @estimate_post.status = 0
    end
    #puts "__________", @estimate_post.status
    @estimate_post.task_triplets=[]

    plan_post.task_triplets.each do |tr|
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


    respond_to do |format|
      if @estimate_post.save
        current_user.journals.build(:type_event=>'estimate_post_save', :body=>@estimate_post.id).save!

        format.html { redirect_to @estimate_post, notice: 'Оценка добавлена' }
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
    redirect_to @estimate_post, notice: 'Оценка успешно обновлена.' 

end

  # DELETE /estimate/posts/1
  # DELETE /estimate/posts/1.json
  def destroy
    @estimate_post = Estimate::Post.find(params[:id])
    @estimate_post.destroy

    respond_to do |format|
      format.html { redirect_to estimate_posts_url }
      format.json { head :no_content }
    end
  end
end
