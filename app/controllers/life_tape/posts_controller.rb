# encoding: utf-8
class LifeTape::PostsController < PostsController



  def voting_model
    Discontent::Aspect
  end
  
def prepare_data
    @project = Core::Project.find(params[:project])
    add_breadcrumb I18n.t('stages.life_tape'), life_tape_posts_path(@project)
    @aspects = Discontent::Aspect.where(:project_id => @project)
    @journals = Journal.events_for_user_feed @project.id
    @my_jounals = Journal.count_events_for_my_feed(@project.id, current_user)
    @news = ExpertNews::Post.where(:project_id => @project).first
    @post_star = LifeTape::Post.where(:project_id => @project, :important => 't' ).limit(3)
    @mini_help = Help::Post.where(stage:1, mini: true).first
    @post_dis = LifeTape::Post.
        where(:project_id => @project).
        reorder('number_views DESC').
        limit(3)
end

  def index

    if @project.status == 2 and ((@project.stage1.to_i - current_user.voted_aspects.size) != 0)
      redirect_to action: "vote_list"
      return
    end

    @post = current_model.new
    @order = params[:order]
    @page = params[:page]
    @folder = :life_tape
    load_filter_for_aspects   if (request.xhr? and @order.nil? and @page.nil?)

    @posts  = current_model.where(:project_id => @project).where(:status => 0)
      .eager_load(:discontent_aspects).where("discontent_aspects.id  IN (?) " , current_user.aspects(@project.id).collect(&:id))
      .order_by_param(@order)
      .paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html
      format.js {render 'posts/index'}
    end
  end


  def vote_list
    @posts = voting_model.where(:project_id => @project, :status => 0)

    @number_v = @project.get_free_votes_for(current_user, :life_tape)
    if @number_v == 0
      redirect_to action: "index"
      return
    end
    @path_for_voting = "/project/#{@project.id}/life_tape/"
    @votes = @project.stage1
    if boss?
      @all_people = @project.users.size
      @voted_people = ActiveRecord::Base.connection.execute("select count(*) as r from (select distinct v.user_id from life_tape_voitings v  left join   discontent_aspects asp on (v.discontent_aspect_id = asp.id) where asp.project_id = #{@project.id}) as dm").first["r"]
      @votes = ActiveRecord::Base.connection.execute("select count(*) as r from (select  v.user_id from life_tape_voitings v  left join   discontent_aspects asp on (v.discontent_aspect_id = asp.id) where asp.project_id = #{@project.id}) as dm").first["r"].to_i
    end
    render :layout => 'application_two_column'
  end



  def to_archive
     super()
    @post.user.add_score(:type => :to_archive_life_tape_post)
  end

  def set_one_vote
    @post = voting_model.find(params[:id])
    @post.toggle(:status)
    @post.update_attributes(status: @post.status)
    respond_to do |format|
      format.js
    end
  end
end
