require "spec_helper"

describe Discontent::AspectsController do
  describe "routing" do

    it "routes to #index" do
      get("project/1/discontent/aspects").should route_to(:action=>"index", :controller=>"discontent/aspects", :project=>"1")
    end

    it "routes to #new" do
      get("project/1/discontent/aspects/new").should route_to(:action=>"new", :controller=>"discontent/aspects", :project=>"1")
    end

    it "routes to #show" do
      get("project/1/discontent/aspects/1").should route_to("discontent/aspects#show", :project => "1", :id => "1")
    end

    it "routes to #edit" do
      get("project/1/discontent/aspects/1/edit").should route_to("discontent/aspects#edit", :project => "1", :id => "1")
    end

    it "routes to #create" do
      post("project/1/discontent/aspects").should route_to("discontent/aspects#create",:project => "1")
    end

    it "routes to #update" do
      put("project/1/discontent/aspects/1").should route_to("discontent/aspects#update",:project => "1",  :id => "1")
    end

    it "routes to #destroy" do
      delete("project/1/discontent/aspects/1").should route_to("discontent/aspects#destroy", :project => "1", :id => "1")
    end

  end
end
