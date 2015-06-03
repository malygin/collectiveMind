include ApplicationHelper

class CommentNotification
  @queue = :comment_notification

  def self.perform(current_model, project_id, current_user_id, name_of_comment_for_param, type, post_id, comment_id, comment_stage)
    # Rails.logger.info current_model
    project = Core::Project.find(project_id)
    current_user = User.find(current_user_id)
    post = current_model.constantize.find(post_id)
    comment = get_comment_for_stage(comment_stage, comment_id)

    project.users_in_project.each do |user|
      if user != current_user && user != comment.user
        current_user.journals.build(type_event: name_of_comment_for_param+'_'+type, user_informed: user, project: project,
                                    body: "#{trim_content(comment.content)}", body2: trim_content(field_for_journal(post)),
                                    first_id: post.id, second_id: comment.id,
                                    personal: true, viewed: false, visible: false).save!
      end
    end
  end
end

class PostNotification
  @queue = :post_notification

  def self.perform(current_model, project_id, current_user_id, name_of_model_for_param, type, post_id)
    project = Core::Project.find(project_id)
    current_user = User.find(current_user_id)
    post = current_model.constantize.find(post_id)

    project.users_in_project.each do |user|
      if user != current_user && user != post.user
        current_user.journals.build(type_event: name_of_model_for_param+'_'+type, user_informed: user, project: project,
                                    body: "#{trim_content(field_for_journal(post))}", first_id: post.id, personal: true, viewed: false, visible: false).save!
      end
    end
  end
end

