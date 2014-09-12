# encoding: utf-8
require 'similar_text'
require 'set'
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

     pr.merge(Concept::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?)", "%#{params[:term]}%")
              .where(:project_id => params[:project], :style => 0).map {|d| {:value => d.value } })

     @project = Core::Project.find(params[:project])
     if @project.status == 9
       pr.merge(Plan::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?)", "%#{params[:term]}%")
                .where(:project_id => params[:project], :style => 0).map {|d| {:value => d.value } })
     end
     render json: pr.sort_by{|ha| ha[:value].downcase}
  end

  def autocomplete_concept_post_mean
    pr=Set.new
    pr.merge(Concept::Resource.where(:project_id => params[:project]).map {|d| {:value => d.name}})

    pr.merge(Concept::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?)", "%#{params[:term]}%")
             .where(:project_id => params[:project], :style => 1).map {|d| {:value => d.value } })

    @project = Core::Project.find(params[:project])
    if @project.status == 9
      pr.merge(Plan::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?)", "%#{params[:term]}%")
               .where(:project_id => params[:project], :style => 1).map {|d| {:value => d.value } })
    end
    render json: pr.sort_by{|ha| ha[:value].downcase}
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
    @aspects = Discontent::Aspect.where(:project_id => @project, :status => 0)
    @disposts = Discontent::Post.where(:project_id => @project, :status => 4).order(:id)
    @vote_all = Concept::Voting.by_posts_vote(@project.discontents.by_status(4).pluck(:id).join(", ")).uniq_user.count if @project.status == 8
  end

  def index
    return redirect_to action: "vote_list" if current_user.can_vote_for(:concept, @project) #view_context.get_concept_posts_for_vote?(@project)
    @aspect =  params[:asp] ? Discontent::Aspect.find(params[:asp]) : @project.proc_aspects.order(:id).first
    @comments_all = @project.ideas_comments_for_improve
  end

  def create
    @project = Core::Project.find(params[:project])
    @concept_post = Concept::Post.new
    @post_aspect = Concept::PostAspect.new(params[:pa])
    unless params[:cd].nil?
      params[:cd].each do |cd|
        @concept_post.concept_post_discontents.build(discontent_post_id: cd.to_i)
      end
    end
    @concept_post.post_aspects << @post_aspect
    @concept_post.number_views = 0
    @concept_post.user = current_user
    @concept_post.status = 0
    @concept_post.project = @project
    @concept_post.improve_comment = params[:improve_comment] if params[:improve_comment]
    @concept_post.improve_stage = params[:improve_stage] if params[:improve_stage]

    unless params[:resor_positive_r].nil?
      params[:resor_positive_r].each_with_index do |r,i|
        if r[1][0]!=''
          resource = @concept_post.concept_post_resources.build(:name => r[1][0], :desc => params[:res_positive_r] ? params[:res_positive_r]["#{r[0]}"][0] : '', :type_res => 'positive_r', :project_id => @project.id, :style => 0)
          if params[:resor_positive_s] and params[:resor_positive_s]["#{r[0]}"]
            params[:resor_positive_s]["#{r[0]}"].each_with_index do |m,ii|
              if m!=''
                mean = @concept_post.concept_post_resources.build(:name => m, :desc => params[:res_positive_s] ? params[:res_positive_s]["#{r[0]}"][ii] : '',:type_res => 'positive_s', :project_id => @project.id, :style => 1)
                mean.concept_post_resource = resource
              end
            end
          end
        end
      end
    end
    unless params[:resor_negative_r].nil?
      params[:resor_negative_r].each_with_index do |r,i|
        if r[1][0]!=''
          resource = @concept_post.concept_post_resources.build(:name => r[1][0], :desc => params[:res_negative_r] ? params[:res_negative_r]["#{r[0]}"][0] : '', :type_res => 'negative_r', :project_id => @project.id, :style => 0)
          if params[:resor_negative_s] and params[:resor_negative_s]["#{r[0]}"]
            params[:resor_negative_s]["#{r[0]}"].each_with_index do |m,ii|
              if m!=''
                mean = @concept_post.concept_post_resources.build(:name => m, :desc => params[:res_negative_s] ? params[:res_negative_s]["#{r[0]}"][ii] : '',:type_res => 'negative_s', :project_id => @project.id, :style => 1)
                mean.concept_post_resource = resource
              end
            end
          end
        end
      end
    end
    unless params[:resor_control_r].nil?
      params[:resor_control_r].each_with_index do |r,i|
        if r[1][0]!=''
          resource = @concept_post.concept_post_resources.build(:name => r[1][0], :desc => params[:res_control_r] ? params[:res_control_r]["#{r[0]}"][0] : '', :type_res => 'control_r', :project_id => @project.id, :style => 0)
          if params[:resor_control_s] and params[:resor_control_s]["#{r[0]}"]
            params[:resor_control_s]["#{r[0]}"].each_with_index do |m,ii|
              if m!=''
                mean = @concept_post.concept_post_resources.build(:name => m, :desc => params[:res_control_s] ? params[:res_control_s]["#{r[0]}"][ii] : '',:type_res => 'control_s', :project_id => @project.id, :style => 1)
                mean.concept_post_resource = resource
              end
            end
          end
        end
      end
    end

   respond_to do |format|
      if @concept_post.save
        current_user.journals.build(:type_event=>'concept_post_save', :body=>trim_content(@concept_post.post_aspects.first.title), :first_id => @concept_post.id,  :project => @project).save!
        @aspect_id =  params[:asp_id]
        format.html { redirect_to  aspect_id.nil? ? "/project/#{@project.id}/concept/posts" : "/project/#{@project.id}/concept/posts?asp=#{@aspect_id}" }
        format.js
      else
        format.html { render action: "new" }
        format.js
      end
    end
  end

  def update
    @project = Core::Project.find(params[:project])
    @concept_post = Concept::Post.find(params[:id])
    @concept_post.update_status_fields(params[:pa])
    @post_aspect = Concept::PostAspect.new(params[:pa])
    if check_before_update(params[:cd],params[:pa])
      @concept_post.post_aspects.destroy_all
      @concept_post.concept_post_discontents.destroy_all

      @concept_post.concept_post_resources.by_type('positive_r').destroy_all
      @concept_post.concept_post_resources.by_type('positive_s').destroy_all

      @concept_post.concept_post_resources.by_type('negative_r').destroy_all
      @concept_post.concept_post_resources.by_type('negative_s').destroy_all

      @concept_post.concept_post_resources.by_type('control_r').destroy_all
      @concept_post.concept_post_resources.by_type('control_s').destroy_all
    end
    unless params[:cd].nil?
      params[:cd].each do |cd|
        @concept_post.concept_post_discontents.build(discontent_post_id: cd.to_i)
      end
    end
    @concept_post.post_aspects << @post_aspect

    unless params[:resor_positive_r].nil?
      params[:resor_positive_r].each_with_index do |r,i|
        if r[1][0]!=''
          resource = @concept_post.concept_post_resources.build(:name => r[1][0], :desc => params[:res_positive_r] ? params[:res_positive_r]["#{r[0]}"][0] : '', :type_res => 'positive_r', :project_id => @project.id, :style => 0)
          if params[:resor_positive_s] and params[:resor_positive_s]["#{r[0]}"]
            params[:resor_positive_s]["#{r[0]}"].each_with_index do |m,ii|
              if m!=''
                mean = @concept_post.concept_post_resources.build(:name => m, :desc => params[:res_positive_s] ? params[:res_positive_s]["#{r[0]}"][ii] : '',:type_res => 'positive_s', :project_id => @project.id, :style => 1)
                mean.concept_post_resource = resource
              end
            end
          end
        end
      end
    end
    unless params[:resor_negative_r].nil?
      params[:resor_negative_r].each_with_index do |r,i|
        if r[1][0]!=''
          resource = @concept_post.concept_post_resources.build(:name => r[1][0], :desc => params[:res_negative_r] ? params[:res_negative_r]["#{r[0]}"][0] : '', :type_res => 'negative_r', :project_id => @project.id, :style => 0)
          if params[:resor_negative_s] and params[:resor_negative_s]["#{r[0]}"]
            params[:resor_negative_s]["#{r[0]}"].each_with_index do |m,ii|
              if m!=''
                mean = @concept_post.concept_post_resources.build(:name => m, :desc => params[:res_negative_s] ? params[:res_negative_s]["#{r[0]}"][ii] : '',:type_res => 'negative_s', :project_id => @project.id, :style => 1)
                mean.concept_post_resource = resource
              end
            end
          end
        end
      end
    end
    unless params[:resor_control_r].nil?
      params[:resor_control_r].each_with_index do |r,i|
        if r[1][0]!=''
          resource = @concept_post.concept_post_resources.build(:name => r[1][0], :desc => params[:res_control_r] ? params[:res_control_r]["#{r[0]}"][0] : '', :type_res => 'control_r', :project_id => @project.id, :style => 0)
          if params[:resor_control_s] and params[:resor_control_s]["#{r[0]}"]
            params[:resor_control_s]["#{r[0]}"].each_with_index do |m,ii|
              if m!=''
                mean = @concept_post.concept_post_resources.build(:name => m, :desc => params[:res_control_s] ? params[:res_control_s]["#{r[0]}"][ii] : '',:type_res => 'control_s', :project_id => @project.id, :style => 1)
                mean.concept_post_resource = resource
              end
            end
          end
        end
      end
    end

    respond_to do |format|
      if @concept_post.save
        current_user.journals.build(:type_event=>'concept_post_update', :body => trim_content(@concept_post.post_aspects.first.title), :first_id=>@concept_post.id,  :project => @project).save!
        @aspect_id =  @project.proc_aspects.order(:id).first.id
        format.html { redirect_to action: "show", :project => @project, :id => @concept_post.id }
        format.js
      else
        format.html { render action: "edit" }
        format.js
      end
    end
  end

  def vote_list
    @project = Core::Project.find(params[:project])
    return redirect_to action: "index" unless current_user.can_vote_for(:concept,  @project)

    disposts = Discontent::Post.where(:project_id => @project, :status => 4).order(:id)
    last_vote = current_user.concept_post_votings.by_project_votings(@project).last
    @discontent_post = current_user.able_concept_posts_for_vote(@project,disposts,last_vote)
    unless @discontent_post.nil?
      var_for_vote = @discontent_post.concepts_for_vote(@project,current_user,last_vote)
      @post_all = var_for_vote[0]
      @concept1 = var_for_vote[1]
      @concept2 = var_for_vote[2]
      @votes = var_for_vote[3]
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
    if current_user.can_vote_for(:concept, @project)
      count_create.times do
        @last_now = Concept::Voting.create(:user_id => current_user.id, :concept_post_aspect_id => params[:id], :discontent_post_id => params[:dis_id])
      end
    end
    @discontent_post = current_user.able_concept_posts_for_vote(@project,disposts,@last_now)
    unless @discontent_post.nil?
      var_for_vote = @discontent_post.concepts_for_vote(@project,current_user,@last_now)
      @post_all = var_for_vote[0]
      @concept1 = var_for_vote[1]
      @concept2 = var_for_vote[2]
      @votes = var_for_vote[3]
    end
  end

  def new
    @asp = Discontent::Aspect.find(params[:asp]) unless params[:asp].nil?
    @concept_post = current_model.new
    @discontent_post = Discontent::Post.find(params[:dis_id]) unless params[:dis_id].nil?
    @resources = Concept::Resource.where(:project_id => @project.id)
    @pa = Concept::PostAspect.new
    @comment = "#{get_class_for_improve(params[:improve_stage].to_i)}::Comment".constantize.find(params[:improve_comment]) if params[:improve_comment] and params[:improve_stage]
    @pa.name = @comment.content if @comment
    @remove_able = true
    respond_to do |format|
      format.html
      format.js
    end
  end

   def edit
     @concept_post = current_model.find(params[:id])
     @pa = @concept_post.post_aspects.first
     @discontent_post = @pa.discontent
     @remove_able = true
     respond_to do |format|
       format.html
       format.js
     end
   end

   def add_dispost
     @project = Core::Project.find(params[:project])
     @dispost = Discontent::Post.find(params[:dispost_id])
   end

  private

    def check_before_update(pa1,pa2)
      pa1 and pa2[:title] and pa2[:name] and pa2[:content] ? true : false
    end

end
