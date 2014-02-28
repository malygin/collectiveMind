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
    @news = ExpertNews::Post.where(:project_id => @project).first
    @post_star = LifeTape::Post.where(:project_id => @project, :important => 't' ).limit(3)
    @mini_help = Help::Post.where(stage:1, mini: true).first
    @post_dis = LifeTape::Post.joins(:comments).
        where(:project_id => @project).
        group('"life_tape_posts"."id"').
        select('"life_tape_posts".*, count(life_tape_comments.id) as count_comment ').
        reorder('count_comment DESC').
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
    load_filter_for_aspects   if (request.xhr? and @order.nil? and @page.nil?)

    @posts  = current_model.where(:project_id => @project)
      .eager_load(:discontent_aspects).where("discontent_aspects.id  IN (?) " , current_user.aspects(@project.id).collect(&:id))
      .order_by_param(@order)
      .paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html
      format.js
    end
  end


  def vote_list
    @posts = voting_model.where(:project_id => @project)

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



end
