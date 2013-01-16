# encoding: utf-8

class Plan::PostsController < ApplicationController
  # GET /plan/posts
  # GET /plan/posts.json
  def prepare_data
    top_posts = Plan::Post.where(:status => '0').sort_by { |p| p.users.size }
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
    @plan_posts = Plan::Post.where(:status => status).paginate(:page => params[:page])
    prepare_data
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plan_posts }
    end
  end

  # GET /Plan/posts/1
  # GET /Plan/posts/1.json
  def show
    @plan_post = Plan::Post.find(params[:id])
    @plan_post.update_column(:number_views, @plan_post.number_views+1)

    @comment = Plan::Comment.new
    prepare_data
  
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plan_post }
    end
  end
  #todo union method for all comments and partials
  def add_comment
    post = Plan::Post.find(params[:id])
    unless  params[:plan_comment][:content]==""
      post.comments.create(:content => params[:plan_comment][:content], :user =>current_user)
      current_user.journals.build(:type_event=>'plan_comment_save', :body=>post.id).save!
      flash[:success] = "Комментарий добавлен"
    else
      flash[:success] = "Введите текст комментария"
    end
    redirect_to post

  end

  # GET /Plan/posts/new
  # GET /Plan/posts/new.json
  def new
    #puts params

    @plan_post = Plan::Post.new
    @plan_post.task_triplets << Plan::TaskTriplet.new(:task =>'1. Оценивание студентами качества образования:  ', :supply => '', :howto => '')
    @plan_post.task_triplets << Plan::TaskTriplet.new(:task =>'2. «Горячая линия»:  ', :supply => '', :howto => '')
    @plan_post.task_triplets << Plan::TaskTriplet.new(:task =>'3. Видео лекций: ', :supply => '', :howto => '')
    @plan_post.task_triplets << Plan::TaskTriplet.new(:task =>'4. Содействие в устройстве на практику, стажировку и работу: ', :supply => '', :howto => '')
    @plan_post.task_triplets << Plan::TaskTriplet.new(:task =>'5. Представление студентов перед потенциальными работодателями: ', :supply => '', :howto => '')
    @plan_post.task_triplets << Plan::TaskTriplet.new(:task =>'6. Видеоконференции с малыми группами: ', :supply => '', :howto => '')
    @plan_post.task_triplets << Plan::TaskTriplet.new(:task =>'7. Разбор материала на жизненных примерах: ', :supply => '', :howto => '')
    prepare_data
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @plan_post }
    end
  end

  def to_expert
    prepare_data
    @note = Plan::PostNote.new
  end 

  def expert_rejection
    prepare_data
    @note = Plan::PostNote.new
  end 
  
  def expert_revision
    prepare_data
    @note = Plan::PostNote.new
  end 

  def save_note(params, status, message, type_event)
    plan = Plan::Post.find(params[:id])
    if !params[:plan_post_note].nil? and params[:plan_post_note][:content]!= ''
      @note = Plan::PostNote.new(params[:plan_post_note])
      @note.post = plan
      @note.user = current_user
      @note.save
    end
    plan.update_column(:status, status)
    current_user.journals.build(:type_event=>type_event, :body=>plan.id).save!
    flash[:notice]=message
    plan
  end

  def to_expert_save
    save_note(params, 2, 'Проект отправлен эксперту!','plan_post_to_expert' )
    redirect_to  action: "index"    
  end

  def expert_rejection_save
    save_note(params, 1, 'Проект отклонен!','plan_post_rejection' )
    redirect_to  action: "index"
  end

  def expert_acceptance_save
    plan = save_note(params, 3, 'Проект принят!','plan_post_acceptance' )
    plan.user.update_column(:score, plan.user.score + 400)
    redirect_to  action: "index"
  end

  def expert_revision_save
    save_note(params, 0, 'Проект отправлен на доработку!','plan_post_revision' )
    redirect_to  action: "index"
  end


  # GET /Plan/posts/1/edit
  def edit
    @plan_post = Plan::Post.find(params[:id])
    prepare_data
  end

  def plus
    post = Plan::Post.find(params[:id])
    post.post_voitings.create(:user => current_user, :post => post)
    render json:post.users.count 
  end
  # POST /Plan/posts
  # POST /Plan/posts.json
  def create
    @plan_post = Plan::Post.new(params[:plan_post])
    # unless params['idea'].nil?
    #   @plan_post.life_tape_post_id = params['idea']
    # end
    @plan_post.number_views =0
    @plan_post.user = current_user
    @plan_post.status = 0
    @plan_post.task_triplets = []
    #puts params['task_supply']
    position=1
    params['task_triplet'].each do |k,v|
      if v['1']!= '' or v['2']!= ''
        triplet = Plan::TaskTriplet.new(:task => v['1'], :supply => v['2'], :howto => v['3'], :position => position) 
        position+=1
        @plan_post.task_triplets << triplet
      end
    end

    respond_to do |format|
      if @plan_post.save
         current_user.journals.build(:type_event=>'plan_post_save', :body=>@plan_post.id).save!
        format.html { redirect_to  action: "index" , notice: 'Проект добавлен!' }
        format.json { render json: @plan_post, status: :created, location: @plan_post }
      else
        format.html { render action: "new" }
        format.json { render json: @plan_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /Plan/posts/1
  # PUT /Plan/posts/1.json
  def update
    @plan_post = Plan::Post.find(params[:id])
    respond_to do |format|
      if @plan_post.update_attributes(params[:plan_post])
         @plan_post.task_triplets =[]
         unless params['task_triplet'].nil?
          position=1

          params['task_triplet'].each do |k,v|
            if v['1']!= '' or v['2']!= ''
              triplet = Plan::TaskTriplet.new(:task => v['1'], :supply => v['2'], :howto => v['3'], :position => position) 
              position+=1
              @plan_post.task_triplets << triplet
            end
          end   
         end
         
        @plan_post.save
        current_user.journals.build(:type_event=>'plan_post_update', :body=>@plan_post.id).save!

        format.html { redirect_to @plan_post, notice: 'Проект успешно изменен!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @plan_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /Plan/posts/1
  # DELETE /Plan/posts/1.json
  def destroy
    @plan_post = Plan::Post.find(params[:id])
    @plan_post.status = 1
    @plan_post.save

    respond_to do |format|
      format.html { redirect_to  action: "index", notice: "Проект перемещен в архив" }
      format.json { head :no_content }
    end
  end

end
