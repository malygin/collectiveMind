require 'spec_helper'

describe Frustration do

	before(:each) do
		@user = FactoryGirl.create(:user)
		@attr = {
			:content => "value for content",
		}
		@attr_user = {:name => "MYNAME" , :surname => "SURNAME", :email => "example@gmail.com",
				 :password => "foobar", :password_confirmation => "foobar"}
	end

	it "should create a new instance given valid attributes" do
		@user.frustrations.create!(@attr)
	end

	describe "user associations" do

		before(:each) do
			@frustration = @user.frustrations.create(@attr)
		end

		it "should have a user attribute" do 
			@frustration.should respond_to(:user)
		end 

		it "should have the right associated user" do
			@frustration.user_id.should == @user.id
			@frustration.user.should == @user
		end
	end 

	describe "frustration associations" do
		 before(:each) do
		 	@user = User.create!(@attr_user)
		 	@fr1 = FactoryGirl.create(:frustration, :user => @user, :created_at => 1.day.ago)
		 	@fr2 = FactoryGirl.create(:frustration, :user => @user, :created_at => 1.hour.ago)
		 end

		 it "should have a frustration attribute" do
		 	@user.should respond_to(:frustrations)
		 end

		 it "should have the right frustration in the right order" do
		 	@user.frustrations.should == [@fr2, @fr1]
		 end

		 it "should destroy associated frustration" do
		 	@user.destroy
		 	[@fr1, @fr2].each do |fr|
		 		Frustration.find_by_id(fr.id).should be_nil
		 	end
		 end
	end

	describe "frustration validation" do

		it "should require user" do
			Frustration.create(@attr).should_not be_valid
		end

		it "should require non-blank content" do
			@user.frustrations.build(:content => " ").should_not be_valid
		end

		it "shoul reject toooo long content" do 
			@user.frustrations.build(:content => "a"*1000).should_not be_valid
		end

	end
	describe "showing" do
			
			before(:each) do
				#@user = FactoryGirl.create(:user)
				@fr_struct= FactoryGirl.create(:frustration, :user => @user, :structure => true)
				@fr_unstruct= FactoryGirl.create(:frustration, :user => @user, :structure => false)
			end

			describe "structure feed" do

				it "should show structure fructions" do
					Frustration.feed_structure.include?(@fr_struct).should be_true  
				end
				it "shouldn't show unstructure fructions" do
					Frustration.feed_structure.include?(@fr_unstruct).should be_false  
				end

			end

			describe "unstructure feed" do

				it "should show unstructure fructions" do
					Frustration.feed_unstructure.include?(@fr_unstruct).should be_true  
				end
				it "shouldn't show structure fructions" do
					Frustration.feed_unstructure.include?(@fr_struct).should be_false  
				end

			end
	end

end
