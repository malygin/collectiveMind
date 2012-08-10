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
  end

  #TODO
  def structure_frustrations
      @frustration = Frustration.new 
      @frustrations_feed = Frustration.feed_structure.paginate(:page => params[:page])
      render 'home'
  end

  def archive_frustrations
    @frustration = Frustration.new
    @frustrations_feed = Frustration.feed_archive.paginate(:page => params[:page]) 
    render 'home'
  end
  def unstructure_frustrations
      @frustration = Frustration.new 
      @frustrations_feed = Frustration.feed_unstructure.paginate(:page => params[:page])
      render 'home'
  end


end
