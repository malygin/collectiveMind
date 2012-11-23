require "spec_helper"

describe ExpertNews::PostsController do
  describe "routing" do

    it "routes to #index" do
      get("/expert_news/posts").should route_to("expert_news/posts#index")
    end

    it "routes to #new" do
      get("/expert_news/posts/new").should route_to("expert_news/posts#new")
    end

    it "routes to #show" do
      get("/expert_news/posts/1").should route_to("expert_news/posts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/expert_news/posts/1/edit").should route_to("expert_news/posts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/expert_news/posts").should route_to("expert_news/posts#create")
    end

    it "routes to #update" do
      put("/expert_news/posts/1").should route_to("expert_news/posts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/expert_news/posts/1").should route_to("expert_news/posts#destroy", :id => "1")
    end

  end
end
