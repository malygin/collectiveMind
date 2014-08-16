# encoding: utf-8
class LifeTape::PostsController < PostsController
  # layout 'application_two_column'

  after_filter :journals_viewed, only: [:index]

  def voting_model
    Discontent::Aspect
  end
  
  def prepare_data
    @project = Core::Project.find(params[:project])
    @aspects = Discontent::Aspect.where(:project_id => @project)
  end

  def index
    @page = params[:page]
    return redirect_to action: "vote_list" if current_user.can_vote_for(:life_tape,  @project)
    @aspect =  params[:asp] ? Discontent::Aspect.find(params[:asp]) : @project.aspects.order(:id).first
    @post_show = @aspect.life_tape_posts.first unless @aspect.nil?
    @comments= @post_show.comments.where(:comment_id => nil).paginate(:page => @page ? @page: last_page, :per_page => 10) if @post_show
    @comment = LifeTape::Comment.new
  end

  def vote_list
    @posts = voting_model.scope_vote_top(@project.id,params[:revers])
    return redirect_to action: "index" unless current_user.can_vote_for(:life_tape,  @project)
    @path_for_voting = "/project/#{@project.id}/life_tape/"
    @votes = @project.stage1
    respond_to do |format|
      format.html
      format.js
    end
  end

  #@todo перенос комментов(вместе с ответами) между темами
  def transfer_comment
    @project = Core::Project.find(params[:project])
    aspect =  Discontent::Aspect.find(params[:aspect_id])
    post = aspect.life_tape_posts.first
    comment = LifeTape::Comment.find(params[:comment_id])
    aspect_old = comment.post.discontent_aspects.first
    unless post.nil?
      comment.update_attributes(post_id: post.id)
      unless comment.comments.nil?
        comment.comments.each do |c|
          c.update_attributes(post_id: post.id)
        end
      end
      #корректировка ссылок в новостях
      Journal.events_for_transfer_comment(@project, comment, aspect_old.id, aspect.id)
    end
    respond_to do |format|
      #@todo нельзя так делать - делай вью и там вызывай алерт
      format.js {render js: "alert('Перенесено');"}
    end
  end

  def to_archive
    super()
    @post.user.add_score(:type => :to_archive_life_tape_post)
  end

  #@todo перевод аспекта в дополнительные и обратно при голосовании
  def set_aspect_status
    @post = voting_model.find(params[:id])
    @post.toggle!(:status)
    respond_to do |format|
      format.js
    end
  end

  #@todo будет полностью перерабатываться на всех трех этапах
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
