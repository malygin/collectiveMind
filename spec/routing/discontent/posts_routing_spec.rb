require "spec_helper"

describe Discontent::PostsController do
  describe "routing" do

    it "routes to #index" do
      get("/discontent/posts").should route_to("discontent/posts#index")
    end

    it "routes to #new" do
      get("/discontent/posts/new").should route_to("discontent/posts#new")
    end

    it "routes to #show" do
      get("/discontent/posts/1").should route_to("discontent/posts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/discontent/posts/1/edit").should route_to("discontent/posts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/discontent/posts").should route_to("discontent/posts#create")
    end

    it "routes to #update" do
      put("/discontent/posts/1").should route_to("discontent/posts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/discontent/posts/1").should route_to("discontent/posts#destroy", :id => "1")
    end

  end
end
