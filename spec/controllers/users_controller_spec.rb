require 'spec_helper'


describe UsersController do

  let(:user) { FactoryGirl.create(:user) }
  # let(:other_user) { FactoryGirl.create(:user) }

   before { sign_in user }

    describe "GET #index" do 
      it "populates an array of users" do
        get :index
        assigns(:users).should include(user)
      end 
      it "renders the :index view" do
        get :index 
        response.should render_template :index 
      end
    end 

    describe "GET #show" do 

      it  "render sign page if user not autorized" do
        sign_out
        get :show, id: user.id 
        response.should redirect_to signin_path
        assigns(:user).should_not eq(user)
      end
      it "assigns the requested user to user" do  
        get :show, id: user.id 
        response.should be_success
        assigns(:user).should eq(user)
      end 

      it "renders the #show view" do 
        get :show, id: user.id
        response.should render_template :show 
      end 
    end 
    describe "POST create" do 
      context "with valid attributes" do
        it "creates a new user" do 
          expect{
             post :create, user: FactoryGirl.attributes_for(:user) 
          }.to change(User,:count).by(1)
        end
      end 
      context "with invalid attributes" do 
        it "does not save the new user" do 
          expect{ 
            post :create, user: FactoryGirl.attributes_for(:invalid_user) 
            }.to_not change(User,:count) 
          end
        end 
    end 
  # describe "destroying a relationship with Ajax" do

  #   before { user.follow!(other_user) }
  #   let(:relationship) { user.relationships.find_by_followed_id(other_user) }
    
  #   it "should decrement the Relationship count" do
  #     expect do
  #       xhr :delete, :destroy, id: relationship.id
  #     end.should change(Relationship, :count).by(-1)
  #   end

  #   it "should respond with success" do
  #     xhr :delete, :destroy, id: relationship.id
  #     response.should be_success
  #   end
  # end
end