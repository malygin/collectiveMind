require 'spec_helper'


describe LifeTape::PostsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:project) { FactoryGirl.create(:project) }
  let(:user_post) { FactoryGirl.create(:life_tape_post, user: user, project: project)}
  let(:admin_post) { FactoryGirl.create(:life_tape_post, user: admin, project: project)}
  # let(:other_user) { FactoryGirl.create(:user) }

   # before { 

   #  FactoryGirl.create(:life_tape_post, user: :admin)
   #  sign_in user }

    describe "GET #index" do 
      it "list of users post" do
        get :index, :project => project
        assigns(:posts_user).should include(user_post)
        assigns(:posts_user).should_not include(admin_post)
      end 
      it "list of facilitator's post" do
        get :index, :project => project
        assigns(:posts_facil).should include(admin_post)
        assigns(:posts_facil).should_not include(user_post)
      end 
      # it "renders the :index view" do
      #   get :index 
      #   response.should render_template :index 
      # end
    end 


end