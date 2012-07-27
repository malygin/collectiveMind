require 'spec_helper'

describe UsersController do
	render_views
	describe "GET 'show'" do
		before(:each) do
			@user = Factory(:user)
		end

		it "should be successful" do
			get :show, :id =>@user
			response.should be_success
		end

		it "should find the right user" do
			get :show, :id => @user
			assigns(:user).should == @user
		end
	end

	describe "GET 'new'" do
	    it "should be successful" do
	      get :new
	      response.should be_success
	    end
	end

	describe "POST 'create'" do
		describe "failure" do
			before(:each) do
				@attr = { :name=>"", :surname=>"", :password=>"", :password_confirmation =>""}
			end

			it "should not create a user" do
				lambda do
					post :create, :user =>@attr
				end.should_not change(User, :count)
			end

		end
	end
end