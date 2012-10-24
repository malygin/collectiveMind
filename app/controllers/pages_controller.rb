# encoding: utf-8
class PagesController < ApplicationController
    before_filter :expert?, :only => :to_expert_frustrations

  def contacts
  end

  def about
  end 

  def donot
  end

  def help
  end  

  def articles
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
    render 'expert'
  end

  def accepted_frustrations
    @frustrations_feed = Frustration.feed_accepted.paginate(:page => params[:page])
    @title = "Принятые на данный момент недовольства"
    render 'home'
  end   

   def declined_frustrations
    @frustrations_feed = Frustration.feed_declined.paginate(:page => params[:page])
    @title = "Отклоненные недовольства"
    render 'expert'
  end       


end
