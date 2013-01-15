require "spec_helper"

describe Estimate::PostsController do
  describe "routing" do

    it "routes to #index" do
      get("/estimate/posts").should route_to("estimate/posts#index")
    end

    it "routes to #new" do
      get("/estimate/posts/new").should route_to("estimate/posts#new")
    end

    it "routes to #show" do
      get("/estimate/posts/1").should route_to("estimate/posts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/estimate/posts/1/edit").should route_to("estimate/posts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/estimate/posts").should route_to("estimate/posts#create")
    end

    it "routes to #update" do
      put("/estimate/posts/1").should route_to("estimate/posts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/estimate/posts/1").should route_to("estimate/posts#destroy", :id => "1")
    end

  end
end
