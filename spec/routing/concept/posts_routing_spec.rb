require "spec_helper"

describe Concept::PostsController do
  describe "routing" do

    it "routes to #index" do
      get("/concept/posts").should route_to("concept/posts#index")
    end

    it "routes to #new" do
      get("/concept/posts/new").should route_to("concept/posts#new")
    end

    it "routes to #show" do
      get("/concept/posts/1").should route_to("concept/posts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/concept/posts/1/edit").should route_to("concept/posts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/concept/posts").should route_to("concept/posts#create")
    end

    it "routes to #update" do
      put("/concept/posts/1").should route_to("concept/posts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/concept/posts/1").should route_to("concept/posts#destroy", :id => "1")
    end

  end
end
