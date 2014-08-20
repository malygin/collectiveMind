# encoding: utf-8
class Concept::PostsController < PostsController

  autocomplete :concept_post, :resource, :class_name => 'Concept::Post' , :full => true

  def current_model
    Concept::Post
  end
  
  def comment_model
    Concept::Comment
  end

  def voting_model  
    Concept::PostAspect
  end

  def note_model
    Concept::Note
  end

  def autocomplete_concept_post_resource
     pr=Set.new
     pr.merge(Concept::Resource.where(:project_id => params[:project]).map {|d| {:value => d.name}})

     pr.merge(Concept::PostResource.select("DISTINCT name as value").joins(:concept_post).where("LOWER(name) like LOWER(?) AND concept_posts.project_id = ?", "%#{params[:term]}%", params[:project] )
              .map {|d| {:value => d.value } })

     @project = Core::Project.find(params[:project])
     if @project.status == 9
       pr.merge(Plan::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?) AND project_id = ?", "%#{params[:term]}%", params[:project])
            .map {|d| {:value => d.value } })
       pr.merge(Plan::PostMean.select("DISTINCT name as value").where("LOWER(name) like LOWER(?) AND project_id = ?", "%#{params[:term]}%", params[:project])
            .map {|d| {:value => d.value } })
       pr.merge(Plan::PostActionResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?) AND project_id = ?", "%#{params[:term]}%", params[:project])
                .map {|d| {:value => d.value } })
     end

     render json: pr.sort_by{|ha| ha[:value].downcase}
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
    @aspects = Discontent::Aspect.where(:project_id => @project, :status => 0)
    @disposts = Discontent::Post.where(:project_id => @project, :status => 4).order(:id)
    @status = 4
    if @project.status == 8
      @vote_all = Concept::Voting.by_posts_vote(@project.discontents.by_status(4).pluck(:id).join(", ")).uniq_user.count
    end
  end

  def index
    if @project.status == 8
      if view_context.get_concept_posts_for_vote?(@project)
        return redirect_to action: "vote_list"
      end
    end
    @aspect_post =  params[:asp] ? Discontent::Aspect.find(params[:asp]) : @project.aspects.order(:id).first

    life_tape_post = @aspect_post.life_tape_post
    if life_tape_post
      life_tape_comments = life_tape_post.comments.where(:concept_status => true)

      discontent_comments = @project.improve_discontent_comments(3)
      concept_comments = @project.improve_concept_comments
      @comments_all = life_tape_comments | discontent_comments | concept_comments
      @comments_all = @comments_all.sort_by{|c| c.improve_concepts.size}
    end
  end

  def create
    @project = Core::Project.find(params[:project])
    @concept_post = Concept::Post.new
    params[:pa].each do |pa|
      post_aspect = Concept::PostAspect.new(pa[1])
      if pa[0] == '0'
        disc = Discontent::Post.find(params[:cd].first) if params[:cd].present?
      else
        disc = Discontent::Post.find(pa[0])
      end
      post_aspect.discontent = disc
      @concept_post.post_aspects << post_aspect
    end
    user_for_post = params[:select_for_clubers].present? ? User.find(params[:select_for_clubers]) : current_user
    @concept_post.number_views =0
    @concept_post.user = user_for_post
    @concept_post.status = 0
    @concept_post.project = @project
    @concept_post.improve_comment = params[:improve_comment] if params[:improve_comment]
    @concept_post.improve_stage = params[:improve_stage] if params[:improve_stage]

    unless params[:resor_positive_r].nil?
      params[:resor_positive_r].each_with_index do |r,i|
        @concept_post.concept_post_resources.build(:name => r, :desc => params[:res_positive_r][i], :type_res => 'positive_r', :project_id => @project.id).save  if r!=''
      end
    end
    unless params[:resor_negative_r].nil?
      params[:resor_negative_r].each_with_index do |r,i|
        @concept_post.concept_post_resources.build(:name => r, :desc => params[:res_negative_r][i], :type_res => 'negative_r', :project_id => @project.id).save  if r!=''
      end
    end

   respond_to do |format|
      if @concept_post.save!
        unless params[:cd].nil?
          params[:cd].each do |cd|
            Concept::PostDiscontent.create(post_id: @concept_post.id, discontent_post_id: cd.to_i)
          end
        end
        user_for_post.journals.build(:type_event=>'concept_post_save', :body=>trim_content(@concept_post.post_aspects.first.title),   :first_id => @concept_post.id,  :project => @project).save!
        aspect_id =  params[:asp_id]
        format.html { redirect_to  aspect_id.nil? ? "/project/#{@project.id}/concept/posts" : "/project/#{@project.id}/concept/posts?asp=#{aspect_id}" }
        format.json { render json: @concept_post, status: :created, location: @concept_post }
      else
        format.html { render action: "new" }
        format.json { render json: @concept_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @project = Core::Project.find(params[:project])

    @concept_post = Concept::Post.find(params[:id])
    @concept_post.update_status_fields(params[:pa],params[:resor_positive_r],params[:res_positive_r],params[:resor_negative_r],params[:res_negative_r])
    @concept_post.post_aspects.destroy_all

    params[:pa].each do |pa|
      post_aspect = Concept::PostAspect.new(pa[1])
      if pa[0] == '0'
        disc = Discontent::Post.find(params[:cd].first) if params[:cd].present?
      else
        disc = Discontent::Post.find(pa[0])
      end
      post_aspect.discontent = disc
      @concept_post.post_aspects << post_aspect
    end
    @concept_post.concept_post_resources.by_type('positive_r').destroy_all
    unless params[:resor_positive_r].nil?
      params[:resor_positive_r].each_with_index do |r,i|
        @concept_post.concept_post_resources.build(:name => r, :desc => params[:res_positive_r][i], :type_res => 'positive_r', :project_id => @project.id).save  if r!=''
      end
    end
    @concept_post.concept_post_resources.by_type('negative_r').destroy_all
    unless params[:resor_negative_r].nil?
      params[:resor_negative_r].each_with_index do |r,i|
        @concept_post.concept_post_resources.build(:name => r, :desc => params[:res_negative_r][i], :type_res => 'negative_r', :project_id => @project.id).save  if r!=''
      end
    end

    respond_to do |format|
      if @concept_post.save!
        @concept_post.concept_post_discontents.destroy_all
        unless params[:cd].nil?
          params[:cd].each do |cd|
            Concept::PostDiscontent.create(post_id: @concept_post.id, discontent_post_id: cd.to_i)
          end
        end
        current_user.journals.build(:type_event=>'concept_post_update', :body => trim_content(@concept_post.post_aspects.first.title), :first_id=>@concept_post.id,  :project => @project).save!

        format.html { redirect_to action: "show", :project => @project, :id => @concept_post.id }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @concept_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def vote_list
    @project = Core::Project.find(params[:project])
    unless view_context.get_concept_posts_for_vote?(@project)
      redirect_to action: "index"
      return
    end

    disposts = Discontent::Post.where(:project_id => @project, :status => 4).order(:id)
    last_vote = current_user.concept_post_votings.by_project_votings(@project).last

    @discontent_post = view_context.able_concept_posts_for_vote(disposts,last_vote)
    unless @discontent_post.nil?
      @post_all = @discontent_post.dispost_concepts.by_status(0).size - 1
      concept_posts = @discontent_post.dispost_concepts.by_status(0).order('concept_posts.id')
      if last_vote.nil? or @discontent_post.id != last_vote.discontent_post_id
        @concept1 = concept_posts[0].post_aspects.first
        @concept2 = concept_posts[1].post_aspects.first
        @votes = 1
      else
        @concept1 = last_vote.concept_post_aspect
        count_now = current_user.concept_post_votings.by_project_votings(@project).where(:discontent_post_id => @discontent_post.id, :concept_post_aspect_id => @concept1.id).count
        index = concept_posts.index @concept1.concept_post
        index = count_now unless index == count_now
        unless concept_posts[index+1].nil?
          @concept2 = concept_posts[index+1].post_aspects.first
          @votes = index+1
        end
      end
    end
  end

  def next_vote
    @project = Core::Project.find(params[:project])
    disposts = Discontent::Post.where(:project_id => @project, :status => 4).order(:id)
    @last_vote = current_user.concept_post_votings.by_project_votings(@project).last

    if @last_vote.nil? or params[:id].to_i == @last_vote.concept_post_aspect_id or params[:dis_id].to_i != @last_vote.discontent_post_id
      count_create = 1
    else
      count_create = current_user.concept_post_votings.by_project_votings(@project).where(:discontent_post_id => @last_vote.discontent_post_id,
                                                             :concept_post_aspect_id => @last_vote.concept_post_aspect_id).count + 1
    end
    if view_context.get_concept_posts_for_vote?(@project)
      count_create.times do
        @last_now = Concept::Voting.create(:user_id => current_user.id, :concept_post_aspect_id => params[:id], :discontent_post_id => params[:dis_id])
      end
    end
    @discontent_post = view_context.able_concept_posts_for_vote(disposts,@last_now)
    unless @discontent_post.nil?
      @post_all = @discontent_post.dispost_concepts.size - 1
      concept_posts = @discontent_post.dispost_concepts.order('concept_posts.id')
      if @discontent_post.id != @last_now.discontent_post_id
        @concept1 = concept_posts[0].post_aspects.first
        @concept2 = concept_posts[1].post_aspects.first
        @votes = 1
      else
        @concept1 = @last_now.concept_post_aspect
        count_now = current_user.concept_post_votings.by_project_votings(@project).where(:discontent_post_id => @discontent_post.id, :concept_post_aspect_id => @concept1.id).count
        index = concept_posts.index @concept1.concept_post
        index = count_now unless index == count_now
        unless concept_posts[index+1].nil?
          @concept2 = concept_posts[index+1].post_aspects.first
          @votes = index+1
        end
      end
    end
  end

  def new
    @asp = Discontent::Aspect.find(params[:asp]) unless params[:asp].nil?
    @post = current_model.new
    @discontent_post = Discontent::Post.find(params[:dis_id]) unless params[:dis_id].nil?
    @resources = Concept::Resource.where(:project_id => @project.id)
    #@users_rc = User.where(:type_user => [4,7])
    @pa = Concept::PostAspect.new
    @comment = "#{get_class_for_improve(params[:improve_stage].to_i)}::Comment".constantize.find(params[:improve_comment]) if params[:improve_comment] and params[:improve_stage]
    @pa.name = @comment.content if @comment
    respond_to do |format|
      format.html
    end
  end

   def edit
     @post = current_model.find(params[:id])
     @pa =@post.post_aspects.first
     @discontent_post = @pa.discontent
   end

   def add_dispost
     @project = Core::Project.find(params[:project])
     @dispost = Discontent::Post.find(params[:dispost_id])
     @remove_able = params[:remove_able]
     respond_to do |format|
       format.js
     end
   end

end
