require "spec_helper"

describe "routes for  different lists of frustrtions " do
	describe PagesController do
	  it "rout unstructure " do
	        get("/frustrations/unstructure").should route_to("pages#unstructure_frustrations")
	  end

	end  

end