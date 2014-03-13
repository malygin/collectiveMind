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

  #def edit11
  #
  #end

  # PUT project/:project/life_tape/posts/:post_id/comments/:id/edit
  #def update_comment
  #  @post = current_model.find(params[:id])
  #  @project = Core::Project.find(params[:project])
  #  @comment = current_model.find(params[:id])
  #  #@project = Core::Project.find(params[:project])
  #
  #  respond_to do |format|
  #    if @comment.update_attributes(params[:comment])
  #      #format.html { redirect_to  :action=>'show', success: 'Комментарий успешно отредактирован' }
  #      format.html {
  #        flash[:success] = 'Комментарий успешно отредактирован'
  #        redirect_to  :action=>'show', :project => @project, :post_id => @post.id}
  #      format.js
  #    else
  #      format.html
  #      format.js
  #    end
  #  end
  #end

  #def update_comment
  #  @project = Core::Project.find(params[:project])
  #  @post = current_model.find(params[:post_id])
  #  @comment = @post.comments.find(params[:id])
  #  if @comment.update_attributes(params[:comment])
  #    respond_to do |format|
  #      format.js {render 'posts/index'}
  #    end
  #  end
  #  #unless  params[name_of_comment_for_param][:content]==''
  #  #  @comment = post.comments.create(:content => params[name_of_comment_for_param][:content], :user =>current_user)
  #  #
  #  ##  flash[:success] = 'Комментарий обновлен'
  #  ##else
  #  ##  flash[:success] = 'Введите текст комментария'
  #  #end
  #end
  def edit_comment
    #@id = params[:id]
    @comment = comment_model.find(params[:id])
  end
  def update_comment
    #@project = Core::Project.find(params[:project])
    #@post = current_model.find(params[:post_id])
    #@comment = @post.comments.find(params[:id])
    #@id = params[:id]
    @comment = comment_model.find(params[:id])
    #@post = @comment.post
    #@post.user = current_user
    if @comment.update_attributes(params[:life_tape_comment])
      respond_to do |format|
        format.js
      end
    end
    #@id = params[:id]
    #comment = comment_model.find(@id)
    #@against =  params[:against] == 'true'
    #comment.comment_votings.create(:user => current_user, :comment => comment,  :against => @against)
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

  def create
    current_user.add_score(:type => :add_life_tape_post)
    super()
  end


  def to_archive
     super()
    @post.user.add_score(:type => :to_archive_life_tape_post)
  end

end
