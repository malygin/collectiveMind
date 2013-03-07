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
    end 

    describe "POST create" do 
       before { sign_in user }

        it "with valid attributes" do 
          expect{
             post :create, :project => project, :life_tape_post => { :content => "Foo" }
          }.to change(LifeTape::Post,:count).by(1)
        end

        it "with invalid attributes" do 
          expect{
             post :create, :project => project, :life_tape_post => { :content => "" }
          }.to_not change(LifeTape::Post,:count)
        end
    end 

    describe "GET #show" do 
      before { sign_in user }


      it "renders the #show view" do 
        get :show, :project => project, id: user_post.id
        response.should render_template :show 
   

      end 
    end 



end