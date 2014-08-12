# encoding: utf-8
class LifeTape::PostsController < PostsController


  def voting_model
    Discontent::Aspect
  end
  
def prepare_data
    @project = Core::Project.find(params[:project])
    add_breadcrumb I18n.t('stages.life_tape'), life_tape_posts_path(@project)
    @aspects = Discontent::Aspect.where(:project_id => @project)

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

      @comments= @post_show.comments.where(:comment_id => nil).paginate(:page => @page ? @page: last_page, :per_page => 10) if @post_show
    else
      @aspect = @project.aspects.order(:id).first
      @post_show = @aspect.life_tape_posts.first unless @aspect.nil?

      @comments= @post_show.comments.where(:comment_id => nil).paginate(:page => @page ? @page: last_page, :per_page => 10) if @post_show

    end
    @post = current_model.new

    if params[:viewed]
      Journal.events_for_content(@project, current_user, @aspect.id).update_all("viewed = 'true'")
      @my_journals_count = @my_journals_count - 1
    end
    @comment = LifeTape::Comment.new

    respond_to do |format|
      format.html{render :layout  => 'application_two_column'}
      format.js {render 'posts/index' }
    end
  end


  def vote_list
    @posts = voting_model.scope_vote_top(@project.id,params[:revers])

    @number_v = @project.get_free_votes_for(current_user, 'lifetape', @project)
    if @number_v == 0  or  @project.status !=2
      redirect_to action: "index"
      return
    end
    @path_for_voting = "/project/#{@project.id}/life_tape/"
    @votes = @project.stage1

    respond_to do |format|
      format.html {render :layout => 'application_two_column'}
      format.js
    end
  end

  def transfer_comment
    @project = Core::Project.find(params[:project])
    aspect =  Discontent::Aspect.find(params[:aspect_id])
    aspect_id =  aspect.id unless aspect.nil?
    post_id = aspect.life_tape_posts.first.id unless aspect.life_tape_posts.first.nil?
    comment = LifeTape::Comment.find(params[:comment_id])
    aspect_old = comment.post.discontent_aspects.first
    aspect_old_id = aspect_old.id unless aspect_old.nil?
    post_old_id = aspect_old.life_tape_posts.first.id unless aspect_old.nil?
    unless post_id.nil?
      comment.update_attributes(post_id: post_id)
      unless comment.comments.nil?
        comment.comments.each do |c|
          c.update_attributes(post_id: post_id)
        end
      end

      journal_comment = Journal.where(:type_event => 'life_tape_comment_save', :project_id => @project.id, :user_id => comment.user, :first_id => aspect_old_id, :second_id => comment.id).first
      my_journal_comment = Journal.where(:type_event => 'my_life_tape_comment', :project_id => @project.id, :user_id => comment.user, :first_id => aspect_old_id, :second_id => comment.id).first
      reply_journal_comment = Journal.where(:type_event => 'reply_life_tape_comment', :project_id => @project.id, :user_id => comment.user, :first_id => aspect_old_id, :second_id => comment.id).first
      journal_comment.update_attributes(first_id: aspect_id) unless journal_comment.nil?
      my_journal_comment.update_attributes(first_id: aspect_id) unless my_journal_comment.nil?
      reply_journal_comment.update_attributes(first_id: aspect_id) unless reply_journal_comment.nil?

      unless comment.comments.nil?
        comment.comments.each do |c|
          journal_comment = Journal.where(:type_event => 'life_tape_comment_save', :project_id => @project.id, :user_id => c.user, :first_id => aspect_old_id, :second_id => c.id).first
          my_journal_comment = Journal.where(:type_event => 'my_life_tape_comment', :project_id => @project.id, :user_id => c.user, :first_id => aspect_old_id, :second_id => c.id).first
          reply_journal_comment = Journal.where(:type_event => 'reply_life_tape_comment', :project_id => @project.id, :user_id => c.user, :first_id => aspect_old_id, :second_id => c.id).first
          journal_comment.update_attributes(first_id: aspect_id) unless journal_comment.nil?
          my_journal_comment.update_attributes(first_id: aspect_id) unless my_journal_comment.nil?
          reply_journal_comment.update_attributes(first_id: aspect_id) unless reply_journal_comment.nil?
        end
      end
    end
    respond_to do |format|
      format.js {render js: "alert('Перенесено');"}
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
    total_results = @post_show.comments.where(:comment_id => nil).count
    page = total_results / 10 + (total_results % 10 == 0 ? 0 : 1)
    page == 0 ? 1 : page
  end

end
