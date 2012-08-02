require 'spec_helper'

describe FrustrationsController do
	render_views

	describe "access control" do

		 it "should deny access to 'create'" do
		 	post :create
		 	response.should redirect_to(signin_path)
		 end 

		 it "should deny access to 'destroy'" do
		 	delete :destroy, :id => 1
		 	response.should redirect_to(signin_path)
		 end
	end

	describe "POST 'create'" do

		before (:each) do
			@user = test_sign_in(FactoryGirl.create(:user))
		end

		describe "failure" do

			before(:each) do 
				@attr = { :content => ""}
			end

			it "should not create frustration" do
				lambda do
					post :create, :frustration => @attr 
				end.should_not change(Frustration, :count)
			end

			it "should render  the home page" do
				post :create, :frustration => @attr
				response.should render_template('pages/home')
			end
		end

		describe "success" do
			
			before(:each) do
				@attr = { :content => "Lorem ipsum"}
			end

			it "should create frustration" do
				lambda do
					post :create, :frustration => @attr
				end.should change(Frustration, :count).by(1)
			end

			it "should redirect to the home page" do
				post :create, :frustration => @attr
				response.should redirect_to(root_path)
			end

		end

	end

	describe "frustrations feed all" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@fr1 = FactoryGirl.create(:frustration, :user => @user, :created_at => 1.day.ago)
			@fr2 = FactoryGirl.create(:frustration, :user => @user, :created_at => 1.hour.ago)			
		end

		it "should include in feed" do
			Frustration.feed_all.include?(@fr1).should be_true
			Frustration.feed_all.include?(@fr2).should be_true
		end	
	end

	describe "DELETE 'destroy'" do

		describe "for an unauthorized user" do

			before(:each) do
				@user = FactoryGirl.create(:user)
				@wrong_user = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
				test_sign_in(@wrong_user)
				@fr = FactoryGirl.create(:frustration, :user => @user)
			end

			it "should deny access" do
				delete :destroy, :id => @fr
				response.should redirect_to root_path
			end
		end

		describe "for authorized user" do

			before(:each) do
				@user = test_sign_in(FactoryGirl.create(:user))
				@fr = FactoryGirl.create(:frustration, :user => @user)
			end

			it "should destroy frustration" do
				lambda do
					delete :destroy, :id => @fr
				end.should change(Frustration, :count).by(-1)
			end
		end

	end

	

end