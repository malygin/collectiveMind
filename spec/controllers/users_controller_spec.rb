require 'spec_helper'

describe UsersController do
	render_views
	describe "GET 'show'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
		end

		it "should be successful" do
			get :show, :id =>@user
			response.should be_success
		end

		it "should find the right user" do
			get :show, :id => @user
			assigns(:user).should == @user
		end
		it "should show the user's frustrations" do
			fr1 = FactoryGirl.create(:frustration, :user => @user, :content => "Foo bar")
			fr2 = FactoryGirl.create(:frustration, :user => @user, :content => "Baz quxx")
			get :show, :id => @user
			#puts response.body
			response.should have_selector("span.content", :content => fr1.content)
			response.should have_selector("span.content", :content => fr2.content)
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