# encoding: utf-8

class ExpertNews::PostsController  < PostsController


  def current_model
    ExpertNews::Post
  end 
  
  def comment_model
    ExpertNews::Comment
  end
  def prepare_data
    @project = Core::Project.find(params[:project])
    add_breadcrumb I18n.t('menu.news'), expert_news_posts_path(@project)
    @journals = Journal.events_for_user_feed @project.id
    @news = ExpertNews::Post.where(:project_id => @project).first
  end
end
