# encoding: utf-8
class LifeTape::PostsController < PostsController



  def voting_model
    Discontent::Aspect
  end
  
def prepare_data
    @project = Core::Project.find(params[:project])
    add_breadcrumb I18n.t('stages.life_tape'), life_tape_posts_path(@project)
    @aspects = Discontent::Aspect.where(:project_id => @project)

    @news = ExpertNews::Post.where(:project_id => @project).first
    @post_star = LifeTape::Post.where(:project_id => @project, :important => 't' ).limit(3)
    @mini_help = Help::Post.where(stage:1, mini: true).first
    @post_dis = LifeTape::Post.
        where(:project_id => @project).
        reorder('number_views DESC').
        limit(3)
end

  def index
    @page = params[:page]
    if @project.status == 2 and ((@project.stage1.to_i - current_user.voted_aspects.by_project(@project).size) != 0)
      redirect_to action: "vote_list"
      return
    end
    if params[:asp]
      @aspect =  Discontent::Aspect.find(params[:asp])
      @post_show = @aspect.life_tape_posts.first

      @comments= @post_show.comments.paginate(:page => @page ? @page: last_page, :per_page => 10)
    else
      @aspect = @project.aspects.first
      @post_show = @aspect.life_tape_posts.first unless @aspect.nil?

      @comments= @post_show.comments.paginate(:page => @page ? @page: last_page, :per_page => 10)

    end

    @post = current_model.new
    # @order = params[:order]

    # @folder = :life_tape

    if params[:viewed]
      Journal.find(params[:viewed]).update_attribute(:viewed, true)
      @my_journals_count = Journal.count_events_for_my_feed(@project.id, current_user)
    end

    @comment = LifeTape::Comment.new
    respond_to do |format|
      format.html{render :layout  => 'application_two_column'}
      format.js {render 'posts/index' }
    end
  end


  def vote_list
    #@posts = voting_model.where(:project_id => @project, :status => 0)

    @posts = voting_model.scope_vote_top(@project.id,params[:revers])

    @number_v = @project.get_free_votes_for(current_user, :life_tape, @project)
    if @number_v == 0  or  @project.status !=2
      redirect_to action: "index"
      return
    end
    @path_for_voting = "/project/#{@project.id}/life_tape/"
    @votes = @project.stage1
    #if boss?
    #  @all_people = @project.users.size
    #  @voted_people = ActiveRecord::Base.connection.execute("select count(*) as r from (select distinct v.user_id from life_tape_voitings v  left join   discontent_aspects asp on (v.discontent_aspect_id = asp.id) where asp.project_id = #{@project.id}) as dm").first["r"]
    #  @votes = ActiveRecord::Base.connection.execute("select count(*) as r from (select  v.user_id from life_tape_voitings v  left join   discontent_aspects asp on (v.discontent_aspect_id = asp.id) where asp.project_id = #{@project.id}) as dm").first["r"].to_i
    #end
    #render :layout => 'application_two_column'
    respond_to do |format|
      format.html {render :layout => 'application_two_column'}
      format.js
    end
  end

  def transfer_comment
    aspect_id =  Discontent::Aspect.find(params[:aspect_id])
    post_id = aspect_id.life_tape_posts.first.id unless aspect_id.life_tape_posts.first.nil?
    comment_id = LifeTape::Comment.find(params[:comment_id])
    comment_old = comment_id.post.discontent_aspects.first.id
    comment_id.update_attributes(post_id: post_id) unless post_id.nil?
    journal_comment = Journal.where(:type_event => 'life_tape_comment_save').where("journals.body like '%#comment_#{comment_id.id}%'").first
    jc = journal_comment.body.sub("asp=#{comment_old}", "asp=#{aspect_id.id}")
    journal_comment.update_attributes(body: jc)
    respond_to do |format|
      format.js {head :ok}
    end
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

  def fast_discussion_topics
    @project = Core::Project.find(params[:project])
    @post = LifeTape::Post.find(params[:post_show]) unless params[:post_show].nil?
    @discontent_aspect = Discontent::Aspect.find(params[:aspect]) unless params[:aspect].nil?

    user_discussion_aspects = current_user.user_discussion_aspects.where(:project_id => @project).pluck(:id)

    if @discontent_aspect.nil?
      aspects_for_discussion = @project.aspects.by_discussions(user_discussion_aspects).order(:id)
      unless aspects_for_discussion.empty?
        aspects_for_discussion.each do |asp|
          @aspect = asp
          @post_show = @aspect.life_tape_posts.first
          break unless @post_show.nil?
        end
      end
    else
      aspects_for_discussion = @project.aspects.by_discussions(user_discussion_aspects).order(:id)
      unless aspects_for_discussion.empty?
        aspects_for_discussion.each do |asp|
          @aspect = asp
          @post_show = @aspect.life_tape_posts.first
          if @aspect.id > @discontent_aspect.id or asp == aspects_for_discussion.last
            if params[:empty_discussion]
              break
            elsif params[:save_form]
              unless params[:discussion].empty?
                @comment = @post.comments.create(:content => params[:discussion], :user => current_user)
                current_user.journals.build(:type_event=>'life_tape_comment'+'_save', :project => @project, :body=>"#{@comment.content[0..48]}:#{@post.id}#comment_#{@comment.id}").save!
                if @post.user!=current_user
                  current_user.journals.build(:type_event=>'my_'+'life_tape_comment', :user_informed => @post.user, :project => @project, :body=>"#{@comment.content[0..24]}:#{@post.id}#comment_#{@comment.id}", :viewed=> false).save!
                end
                current_user.life_tape_post_discussions.create(post: @post, aspect: @discontent_aspect)
              end
              break
            else
              next
            end
          end
        end
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def last_page
    total_results = @post_show.comments.count
    total_results / 10 + (total_results % 10 == 0 ? 0 : 1)
  end

end
