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


    @post = current_model.new

    if request.xhr?
      current_user.discontent_aspect_users.destroy_all
      unless params[:aspects_filter].nil?
        params[:aspects_filter].each do |asp|
          current_user.discontent_aspect_users.create(aspect_id: asp.to_i)
        end
      end
    end
    @posts  = current_model.where(:project_id => @project)
      .eager_load(:discontent_aspects).where("discontent_aspects.id  IN (?) " , current_user.aspects(@project.id).collect(&:id))
      .order_by_param(params[:order])
      .paginate(:page => params[:page])


    respond_to do |format|
      format.html # index.html.erb
      format.js
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
