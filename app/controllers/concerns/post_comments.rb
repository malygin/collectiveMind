module PostComments
  extend ActiveSupport::Concern

  def like_comment
    @comment = comment_model.find(params[:id])
    @against = params[:against]
    @vote = @comment.comment_votings.create(user: current_user, comment: @comment, against: @against) unless @comment.voting_users.include? current_user
    Journal.like_comment_event(current_user, @project, name_of_comment_for_param, @comment, @against)
    respond_to :js
  end

  def add_score_for_comment
    @comment = comment_model.find(params[:id])
    @comment.add_score if boss?
    @main_comment = @comment.comment.id unless @comment.comment.nil?
    respond_to :js
  end

  def edit_comment
    @comment = comment_model.find(params[:id])
    respond_to :js
  end

  def update_comment
    @comment = comment_model.find(params[:id])
    @comment.update_attributes(content: params[:content])
    @aspects = Core::Aspect::Post.where(project_id: @project)
    if params[:image]
      img, isFile = Util::ImageLoader.load(params[name_of_comment_for_param])
      @comment.update_attributes(image: img ? img['public_id'] : nil, isFile: img ? isFile : nil)
    end
    respond_to :js
  end

  def destroy_comment
    @comment = comment_model.find(params[:id])
    if @comment.user == current_user or boss?
      @comment.destroy
      Journal.destroy_comment_journal(@project, @comment)
    end
    respond_to :js
  end


  def add_comment
    @aspects = Core::Aspect::Post.where(project_id: @project)
    if params[:comment]
      @comment_answer = comment_model.find(params[:comment])
      @comment_parent = @comment_answer.comment ? @comment_answer.comment : @comment_answer
    end
    @comment = current_model.find(params[:id]).add_comment(params[name_of_comment_for_param], current_user,
                                                           @comment_parent, @comment_answer, name_of_comment_for_param)
    @new_comment = comment_model.new
    respond_to :js
  end


  def change_status_for_comment
    @post = current_model.find(params[:id])
    @comment = comment_model.find(params[:comment_id])

    @comment.toggle!(:discuss_status) if params[:discuss_status]
    @comment.toggle!(:approve_status) if params[:approve_status]
    if params[:discuss_status]
      if @comment.discuss_status
        type = 'discuss_status'
      end
    elsif params[:approve_status]
      if @comment.approve_status
        type = 'approve_status'
      end
    end
    if type
      current_user.journals.build(type_event: name_of_comment_for_param+'_'+type, project: @project,
                                  body: "#{trim_content(@comment.content)}", body2: trim_content(field_for_journal(@post)),
                                  first_id: @post.id, second_id: @comment.id).save!

      if @comment.user!=current_user
        current_user.journals.build(type_event: 'my_'+name_of_comment_for_param+'_'+type, user_informed: @comment.user, project: @project,
                                    body: "#{trim_content(@comment.content)}", body2: trim_content(field_for_journal(@post)),
                                    first_id: @post.id, second_id: @comment.id,
                                    personal: true, viewed: false).save!
      end
      if @project.closed?
        Resque.enqueue(CommentNotification, current_model.to_s, @project.id, current_user.id, name_of_comment_for_param, type, @post.id, @comment.id, params[:comment_stage])
      end
    end
    respond_to do |format|
      format.js
    end
  end
end