# encoding: utf-8
require 'similar_text'
require 'set'
class Concept::PostsController < PostsController

  autocomplete :concept_post, :resource, class_name: 'Concept::Post' , full: true

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
     pr.merge(Concept::Resource.where(project_id: params[:project]).map {|d| {value: d.name}})

     pr.merge(Concept::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?)", "%#{params[:term]}%")
              .where(project_id: params[:project], style: 0).map {|d| {value: d.value } })

     @project = Core::Project.find(params[:project])
     if @project.status == 9
       pr.merge(Plan::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?)", "%#{params[:term]}%")
                .where(project_id: params[:project], style: 0).map {|d| {value: d.value } })
     end
     render json: pr.sort_by{|ha| ha[:value].downcase}
  end

  def autocomplete_concept_post_mean
    pr=Set.new
    pr.merge(Concept::Resource.where(project_id: params[:project]).map {|d| {value: d.name}})

    pr.merge(Concept::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?)", "%#{params[:term]}%")
             .where(project_id: params[:project], style: 1).map {|d| {value: d.value } })

    @project = Core::Project.find(params[:project])
    if @project.status == 9
      pr.merge(Plan::PostResource.select("DISTINCT name as value").where("LOWER(name) like LOWER(?)", "%#{params[:term]}%")
               .where(project_id: params[:project], style: 1).map {|d| {value: d.value } })
    end
    render json: pr.sort_by{|ha| ha[:value].downcase}
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
    @aspects = Discontent::Aspect.where(project_id: @project, status: 0)
    @disposts = Discontent::Post.where(project_id: @project, status: 4).order(:id)
    @vote_all = Concept::Voting.by_posts_vote(@project.discontents.by_status(4).pluck(:id).join(", ")).uniq_user.count if @project.status == 8
  end

  def index
    return redirect_to action: "vote_list" if current_user.can_vote_for(:concept, @project)
    @aspect =  params[:asp] ? Discontent::Aspect.find(params[:asp]) : (@project.proc_aspects.first.position.nil? ? @project.proc_aspects.order(:id).first : @project.proc_aspects.order("position DESC").first)
    @comments_all = @project.ideas_comments_for_improve
  end

  def create
    @project = Core::Project.find(params[:project])
    @concept_post = Concept::Post.new
    @post_aspect = Concept::PostAspect.new(params[:pa])
    unless params[:cd].nil?
      params[:cd].each do |cd|
        @concept_post.concept_post_discontents.build(discontent_post_id: cd[0],complite: cd[1][:complite], status: 0)
      end
    end
    unless params[:check_discontent].nil?
      params[:check_discontent].each do |com|
        @concept_post.concept_post_discontent_grouped.build(discontent_post_id: com[0], status: 1)
      end
    end

    @concept_post.post_aspects << @post_aspect
    @concept_post.number_views = 0
    @concept_post.user = current_user
    @concept_post.status = 0
    @concept_post.project = @project
    @concept_post.improve_comment = params[:improve_comment] if params[:improve_comment]
    @concept_post.improve_stage = params[:improve_stage] if params[:improve_stage]

    create_concept_resources_on_type(@project, @concept_post)

    respond_to do |format|
      if @concept_post.save
        current_user.journals.build(type_event:'concept_post_save', body:trim_content(@concept_post.post_aspects.first.title), first_id: @concept_post.id,  project: @project).save!
        @aspect_id =  params[:asp_id]
        format.html { redirect_to  @aspect_id.nil? ? "/project/#{@project.id}/concept/posts" : "/project/#{@project.id}/concept/posts?asp=#{@aspect_id}" }
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
      @concept_post.concept_post_discontent_grouped.destroy_all

      @concept_post.concept_post_resources.by_type('positive_r').destroy_all
      @concept_post.concept_post_resources.by_type('positive_s').destroy_all
      @concept_post.concept_post_resources.by_type('negative_r').destroy_all
      @concept_post.concept_post_resources.by_type('negative_s').destroy_all
      @concept_post.concept_post_resources.by_type('control_r').destroy_all
      @concept_post.concept_post_resources.by_type('control_s').destroy_all
    end
    unless params[:cd].nil?
      params[:cd].each do |cd|
        @concept_post.concept_post_discontents.build(discontent_post_id: cd[0],complite: cd[1][:complite], status: 0)
      end
    end
    unless params[:check_discontent].nil?
      params[:check_discontent].each do |com|
        @concept_post.concept_post_discontent_grouped.build(discontent_post_id: com[0], status: 1)
      end
    end
    @concept_post.post_aspects << @post_aspect

    create_concept_resources_on_type(@project, @concept_post)

    respond_to do |format|
      if @concept_post.save
        current_user.journals.build(type_event:'concept_post_update', body: trim_content(@concept_post.post_aspects.first.title), first_id:@concept_post.id,  project: @project).save!
        @aspect_id =  @project.proc_aspects.order(:id).first.id
        format.html { redirect_to action: "show", project: @project, id: @concept_post.id }
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

    disposts = Discontent::Post.where(project_id: @project, status: 4).order(:id)
    last_vote = current_user.concept_post_votings.by_project_votings(@project).last
    @discontent_post = current_user.able_concept_posts_for_vote(@project,disposts,last_vote)
    unless @discontent_post.nil?
      var_for_vote = @discontent_post.concepts_for_vote(@project,current_user,last_vote)
      @post_all = var_for_vote[0]
      @concept1 = var_for_vote[1]
      @concept2 = var_for_vote[2]
      @votes = var_for_vote[3]
    else
      @post_all = 1
      @votes = 0
    end
  end

  def next_vote
    @project = Core::Project.find(params[:project])
    disposts = Discontent::Post.where(project_id: @project, status: 4).order(:id)
    @last_vote = current_user.concept_post_votings.by_project_votings(@project).last

    if @last_vote.nil? or params[:id].to_i == @last_vote.concept_post_aspect_id or params[:dis_id].to_i != @last_vote.discontent_post_id
      count_create = 1
    else
      count_create = current_user.concept_post_votings.by_project_votings(@project).where(discontent_post_id: @last_vote.discontent_post_id,
                                                 concept_post_aspect_id: @last_vote.concept_post_aspect_id).count + 1
    end
    if current_user.can_vote_for(:concept, @project)
      count_create.times do
        @last_now = Concept::Voting.create(user_id: current_user.id, concept_post_aspect_id: params[:id], discontent_post_id: params[:dis_id])
      end
    end
    @discontent_post = current_user.able_concept_posts_for_vote(@project,disposts,@last_now)
    unless @discontent_post.nil?
      var_for_vote = @discontent_post.concepts_for_vote(@project,current_user,@last_now)
      @post_all = var_for_vote[0]
      @concept1 = var_for_vote[1]
      @concept2 = var_for_vote[2]
      @votes = var_for_vote[3]
    else
      @post_all = 1
      @votes = 0
    end
  end

  def new
    @asp = Discontent::Aspect.find(params[:asp]) unless params[:asp].nil?
    @concept_post = current_model.new
    @discontent_post = Discontent::Post.find(params[:dis_id]) unless params[:dis_id].nil?
    @resources = Concept::Resource.where(project_id: @project.id)
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
     @remove_able = true
   end

  private

    def check_before_update(pa1,pa2)
      pa1 and pa2[:title] and pa2[:name] and pa2[:content] ? true : false
    end

    def create_concept_resources_on_type(project, post)
      #if flag_destroy
      #  post.concept_post_resources.by_type(type_r).destroy_all
      #  post.concept_post_resources.by_type(type_s).destroy_all
      #end

      # unless params[:plan_post_resource].nil?
      #   params[:plan_post_resource].each do |t|
      #     t[1].each_with_index do |r,i|
      #       post.concept_post_resources.build(:name => r[:name], :desc => r[:desc],:style => r[:style], :type_res => t[0], :project_id => project.id)
      #     end
      #   end
      # end
      # unless params[('resor_'+type_r).to_sym].nil?
      #   params[('resor_'+type_r).to_sym].each_with_index do |r,i|
      #      if r[1][0]!=''
      #        resource = post.concept_post_resources.build(:name => r[1][0], :desc => params[('resor_'+type_r).to_sym] ? params[('resor_'+type_r).to_sym]["#{r[0]}"][0] : '', :type_res => type_r, :project_id => project.id, :style => 0)
      #        if params[('resor_'+type_s).to_sym] and params[('resor_'+type_s).to_sym]["#{r[0]}"]
      #          params[('resor_'+type_s).to_sym]["#{r[0]}"].each_with_index do |m,ii|
      #            if m!=''
      #              mean = post.concept_post_resources.build(:name => m, :desc => params[('resor_'+type_s).to_sym] ? params[('resor_'+type_s).to_sym]["#{r[0]}"][ii] : '',:type_res => type_s, :project_id => project.id, :style => 1)
      #              mean.concept_post_resource = resource
      #            end
      #          end
      #        end
      #      end
      #   end
      # end
      unless params[:resor].nil?
        params[:resor].each do |r|
          if r[:name]!=''
            resource = post.concept_post_resources.build(:name => r[:name], :desc => r[:desc], :type_res => r[:type_res], :project_id => project.id, :style => 0)
            r[:means].each  do |m|
              if m[:name]!=''
                mean = post.concept_post_resources.build(:name => m[:name], :desc => m[:desc], :type_res => m[:type_res], :project_id => project.id, :style => 1)
                mean.concept_post_resource = resource
              end
            end
          end
        end
      end

  end

end
