require 'spec_helper'

describe PagesController do
	render_views

	describe "showing frustrations feed" do
			
			before(:each) do
				@user = FactoryGirl.create(:user)
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
	end
end