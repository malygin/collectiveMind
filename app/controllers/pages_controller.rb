class PagesController < ApplicationController
  def contacts
  end

  def about
  end

  def help
  end

  def home
  	@frustration = Frustration.new if signed_in?
  end
end
