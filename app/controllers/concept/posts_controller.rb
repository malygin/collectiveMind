# encoding: utf-8

class Concept::PostsController < ApplicationController
  # GET /concept/posts
  # GET /concept/posts.json
    before_filter :authenticate, :only => [:create, :new]

  def prepare_data
    top_posts = Concept::Post.where(:status => '0').sort_by { |p| p.users.size }
    #@top_posts = LifeTape::Post.joins(:post_voitings).select('life_tape_post_voitings.*, count(user_id) as "user_count"').group(:user_id).order(' user_count desc').limit(3)
    @top_posts = top_posts.reverse[0..3]
    @journals = Journal.events_for_user_feed
    @news = ExpertNews::Post.first    
  end

  def index
    status = params['status_id']
    if status.nil?
      status ='0'
    end
    @concept_posts = Concept::Post.where(:status => status).paginate(:page => params[:page])
    prepare_data
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @concept_posts }
    end
  end

  # GET /concept/posts/1
  # GET /concept/posts/1.json
  def show
    @concept_post = Concept::Post.find(params[:id])
    @concept_post.update_column(:number_views, @concept_post.number_views+1)

    @comment = Concept::Comment.new
    prepare_data
  
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @concept_post }
    end
  end
  #todo union method for all comments and partials
  def add_comment
    post = Concept::Post.find(params[:id])
    unless  params[:concept_comment][:content]==""
      post.comments.create(:content => params[:concept_comment][:content], :user =>current_user)
      current_user.journals.build(:type_event=>'concept_comment_save', :body=>post.id).save!
      flash[:success] = "Комментарий добавлен"
    else
      flash[:success] = "Введите текст комментария"
    end
    redirect_to post

  end

  # GET /concept/posts/new
  # GET /concept/posts/new.json
  def new
    #puts params
    unless params['idea'].nil?
      @ltpost = params['idea']
    end
    @concept_post = Concept::Post.new
    @concept_post.task_supply_pairs << Concept::TaskSupplyPair.new(:task =>'', :supply => '')
    prepare_data
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @concept_post }
    end
  end

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
    concept = Concept::Post.find(params[:id])
    if !params[:concept_post_note].nil? and params[:concept_post_note][:content]!= ''
      @note = Concept::PostNote.new(params[:concept_post_note])
      @note.post = concept
      @note.user = current_user
      @note.save
    end
    concept.update_column(:status, status)
    current_user.journals.build(:type_event=>type_event, :body=>concept.id).save!
    flash[:notice]=message
    concept
  end

  def to_expert_save
    save_note(params, 2, 'Концепция отправлена эксперту!','concept_post_to_expert' )
    redirect_to  action: "index"    
  end

  def expert_rejection_save
    save_note(params, 1, 'Концепция отклонена!','concept_post_rejection' )
    redirect_to  action: "index"
  end

  def expert_acceptance_save
    concept = save_note(params, 3, 'Концепция принята!','concept_post_acceptance' )
    concept.user.update_column(:score, concept.user.score + 200)
    redirect_to  action: "index"
  end

  def expert_revision_save
    save_note(params, 0, 'Концепция отправлена на доработку!','concept_post_revision' )
    redirect_to  action: "index"
  end


  # GET /concept/posts/1/edit
  def edit
    @concept_post = Concept::Post.find(params[:id])
    prepare_data
  end

  def plus
    post = Concept::Post.find(params[:id])
    post.post_voitings.create(:user => current_user, :post => post, :against => false)
    render json:post.users.count 
  end
  # POST /concept/posts
  # POST /concept/posts.json
  def create
    @concept_post = Concept::Post.new(params[:concept_post])
    unless params['idea'].nil?
      @concept_post.life_tape_post_id = params['idea']
    end
    @concept_post.number_views =0
    @concept_post.user = current_user
    @concept_post.status = 0
    #@concept_post.task_supply_pairs = nil
    #puts params['task_supply']
    params['task_supply'].each do |k,v|
      if v['1']!= '' or v['2']!= ''
        pair = Concept::TaskSupplyPair.new(:task => v['1'], :supply => v['2']) 
        @concept_post.task_supply_pairs << pair
      end
    end

    respond_to do |format|
      if @concept_post.save
         current_user.journals.build(:type_event=>'concept_post_save', :body=>@concept_post.id).save!
        format.html { redirect_to  action: "index" , notice: 'Концепция добавлена!' }
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
    @concept_post = Concept::Post.find(params[:id])
    respond_to do |format|
      if @concept_post.update_attributes(params[:concept_post])
         @concept_post.task_supply_pairs =[]
         unless params['task_supply'].nil?
          params['task_supply'].each do |k,v|
            if v['1']!= '' or v['2']!= ''
              pair = Concept::TaskSupplyPair.new(:task => v['1'], :supply => v['2']) 
              @concept_post.task_supply_pairs << pair
            end
          end           
         end
         
        @concept_post.save
        current_user.journals.build(:type_event=>'concept_post_update', :body=>@concept_post.id).save!

        format.html { redirect_to @concept_post, notice: 'Концепция успешно изменена!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @concept_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /concept/posts/1
  # DELETE /concept/posts/1.json
  def destroy
    @concept_post = Concept::Post.find(params[:id])
    @concept_post.status = 1
    @concept_post.save

    respond_to do |format|
      format.html { redirect_to  action: "index", notice: "Концепция перемещена в архив" }
      format.json { head :no_content }
    end
  end

  def forecast
    prepare_data
    @forecast_task = Concept::ForecastTask.new
    @forecast_tasks = Concept::ForecastTask.all
  end

  def vote_for
    #puts params
    @forecast_task = Concept::ForecastTask.find(params[:id])
    @forecast_task.voitings.create(:user => current_user, :score => params[:score].to_f-1)
    render json: @forecast_task.voiting_score
  end
  
end
