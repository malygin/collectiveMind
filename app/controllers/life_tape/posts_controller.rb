# encoding: utf-8
class LifeTape::PostsController < PostsController




  def voting_model
    Discontent::Aspect
  end
  
def prepare_data
    @project = Core::Project.find(params[:project]) 
    @aspects = Discontent::Aspect.unscoped.order("position").where(:project_id => @project)
    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.where(:project_id => @project).first
    @post_star = LifeTape::Post.where(:project_id => @project, :important => 't' ).limit(3)

    @post_dis = LifeTape::Post.joins(:comments).
        where(:project_id => @project).
        #reorder('count DESC').
        group('"life_tape_posts"."id"').
        select('"life_tape_posts".*, count(life_tape_comments.id) as count_comment ').
        #reorder('').
        reorder('count_comment DESC').
        limit(3)

    
end

  def index
    if params[:aspect].nil?
      @posts = current_model.where(:project_id => @project).paginate(:page => params[:page]).includes(:discontent_aspects)

    else
      @posts = current_model.where(:project_id => @project, :aspect_id => params[:aspect]).paginate(:page => params[:page])

    end
    @post = current_model.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end


  def vote_list
    @posts = voting_model.where(:project_id => @project)

    @number_v = @project.stage1.to_i - current_user.voted_aspects.size
    @path_for_voting = "/project/#{@project.id}/life_tape/"
    @votes = @project.stage1
    if boss?
      @all_people = @project.users.size

      @voted_people = ActiveRecord::Base.connection.execute("select count(*) as r from (select distinct v.user_id from life_tape_voitings v  left join   discontent_aspects asp on (v.discontent_aspect_id = asp.id) where asp.project_id = #{@project.id}) as dm").first["r"]
      @votes = ActiveRecord::Base.connection.execute("select count(*) as r from (select  v.user_id from life_tape_voitings v  left join   discontent_aspects asp on (v.discontent_aspect_id = asp.id) where asp.project_id = #{@project.id}) as dm").first["r"].to_i
    end
  end

end
