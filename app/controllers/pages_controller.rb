class PagesController < ApplicationController
  def contacts
  end

  def about
  end

  def help
  end

  def home
  	if signed_in?
  		@frustration = Frustration.new 
  		@frustrations_feed = Frustration.paginate(:page => params[:page])
  	end
  end

  #TODO
  def structure_frustrations
    if signed_in?
      @frustration = Frustration.new 
      @frustrations_feed = Frustration.feed_structure.paginate(:page => params[:page])
      render 'home'
    end
  end

  def unstructure_frustrations
    if signed_in?
      @frustration = Frustration.new 
      @frustrations_feed = Frustration.feed_unstructure.paginate(:page => params[:page])
      render 'home'
    end
  end


end
