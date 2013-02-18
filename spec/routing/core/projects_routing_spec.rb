require "spec_helper"

describe Core::ProjectsController do
  describe "routing" do

    it "routes to #index" do
      get("/core/projects").should route_to("core/projects#index")
    end

    it "routes to #new" do
      get("/core/projects/new").should route_to("core/projects#new")
    end

    it "routes to #show" do
      get("/core/projects/1").should route_to("core/projects#show", :id => "1")
    end

    it "routes to #edit" do
      get("/core/projects/1/edit").should route_to("core/projects#edit", :id => "1")
    end

    it "routes to #create" do
      post("/core/projects").should route_to("core/projects#create")
    end

    it "routes to #update" do
      put("/core/projects/1").should route_to("core/projects#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/core/projects/1").should route_to("core/projects#destroy", :id => "1")
    end

  end
end
