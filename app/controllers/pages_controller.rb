# encoding: utf-8
class PagesController < ApplicationController
   layout "core/projects"
    before_filter :expert?, :only => :to_expert_frustrations
    before_filter :get_news

  def prepare_data

    @journals = Journal.events_for_user_feed
    @news = ExpertNews::Post.first    
  end

 

  def get_news
    @news = ExpertNews::Post.first
  end
  
  def home
  		@frustration = Frustration.new 
  		@frustrations_feed = Frustration.feed_unstructure.paginate(:page => params[:page])
      @users = User.only_simple_users.order('users.score DESC').limit(5)
      @title = "Произвольные недовольства" 

  end

  #TODO
  def structure_frustrations
      @frustration = Frustration.new 
      @frustrations_feed = Frustration.feed_structure.paginate(:page => params[:page])
      @users = User.only_simple_users.order('users.score DESC').limit(5) 
      @title = "Оформленные недовольства" 

      render 'home'
  end

  def archive_frustrations
    @frustration = Frustration.new
    @title = "Недовольства снятые с рассмотрения"
    @frustrations_feed = Frustration.feed_archive.paginate(:page => params[:page]) 
    @users = User.only_simple_users.order('users.score DESC').limit(5) 
    render 'home'
  end

  def unstructure_frustrations
      @frustration = Frustration.new 
      @frustrations_feed = Frustration.feed_unstructure.paginate(:page => params[:page])
      @users = User.only_simple_users.order('users.score DESC').limit(5) 
      @title = "Произвольные недовольства" 
      render 'home'
  end

  def to_expert_frustrations
    @frustrations_feed = Frustration.feed_to_expert.paginate(:page => params[:page])
    @title = "Недовольства на рассмотрении"
    render 'home'
  end

  def accepted_frustrations
    @frustrations_feed = Frustration.feed_accepted.paginate(:page => params[:page])
    @title = "Принятые на данный момент недовольства"
    render 'home'
  end    

   def voted_frustrations
    @frustrations_feed = Frustration.feed_voted.paginate(:page => params[:page])
    @title = "Голосование за недовольства"
    @voted = true
    @news = ExpertNews::Post.first

    render 'home'
  end   

   def declined_frustrations
    @frustrations_feed = Frustration.feed_declined.paginate(:page => params[:page])
    @title = "Отклоненные недовольства"
    render 'home'
  end
end
