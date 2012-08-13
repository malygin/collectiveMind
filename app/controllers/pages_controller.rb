# encoding: utf-8
class PagesController < ApplicationController
  def contacts
  end

  def about
  end

  def help
  end

  def home
  		@frustration = Frustration.new 
  		@frustrations_feed = Frustration.feed_unstructure.paginate(:page => params[:page])
      @users = User.order('users.score DESC').limit(5) 
  end

  #TODO
  def structure_frustrations
      @frustration = Frustration.new 
      @frustrations_feed = Frustration.feed_structure.paginate(:page => params[:page])
      @users = User.order('users.score DESC').limit(5) 

      render 'home'
  end

  def archive_frustrations
    @frustration = Frustration.new
    @title = "Неудовлетворенности, снятые с рассмотрения"
    @frustrations_feed = Frustration.feed_archive.paginate(:page => params[:page]) 
    @users = User.order('users.score DESC').limit(5) 

    render 'home'
  end
  def unstructure_frustrations
      @frustration = Frustration.new 
      @frustrations_feed = Frustration.feed_unstructure.paginate(:page => params[:page])
      @users = User.order('users.score DESC').limit(5) 

      render 'home'
  end


end
