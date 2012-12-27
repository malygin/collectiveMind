require "spec_helper"

describe Plan::PostsController do
  describe "routing" do

    it "routes to #index" do
      get("/plan/posts").should route_to("plan/posts#index")
    end

    it "routes to #new" do
      get("/plan/posts/new").should route_to("plan/posts#new")
    end

    it "routes to #show" do
      get("/plan/posts/1").should route_to("plan/posts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/plan/posts/1/edit").should route_to("plan/posts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/plan/posts").should route_to("plan/posts#create")
    end

    it "routes to #update" do
      put("/plan/posts/1").should route_to("plan/posts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/plan/posts/1").should route_to("plan/posts#destroy", :id => "1")
    end

  end
end
