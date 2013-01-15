require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Estimate::PostsController do

  # This should return the minimal set of attributes required to create a valid
  # Estimate::Post. As you add validations to Estimate::Post, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Estimate::PostsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all estimate_posts as @estimate_posts" do
      post = Estimate::Post.create! valid_attributes
      get :index, {}, valid_session
      assigns(:estimate_posts).should eq([post])
    end
  end

  describe "GET show" do
    it "assigns the requested estimate_post as @estimate_post" do
      post = Estimate::Post.create! valid_attributes
      get :show, {:id => post.to_param}, valid_session
      assigns(:estimate_post).should eq(post)
    end
  end

  describe "GET new" do
    it "assigns a new estimate_post as @estimate_post" do
      get :new, {}, valid_session
      assigns(:estimate_post).should be_a_new(Estimate::Post)
    end
  end

  describe "GET edit" do
    it "assigns the requested estimate_post as @estimate_post" do
      post = Estimate::Post.create! valid_attributes
      get :edit, {:id => post.to_param}, valid_session
      assigns(:estimate_post).should eq(post)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Estimate::Post" do
        expect {
          post :create, {:estimate_post => valid_attributes}, valid_session
        }.to change(Estimate::Post, :count).by(1)
      end

      it "assigns a newly created estimate_post as @estimate_post" do
        post :create, {:estimate_post => valid_attributes}, valid_session
        assigns(:estimate_post).should be_a(Estimate::Post)
        assigns(:estimate_post).should be_persisted
      end

      it "redirects to the created estimate_post" do
        post :create, {:estimate_post => valid_attributes}, valid_session
        response.should redirect_to(Estimate::Post.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved estimate_post as @estimate_post" do
        # Trigger the behavior that occurs when invalid params are submitted
        Estimate::Post.any_instance.stub(:save).and_return(false)
        post :create, {:estimate_post => {}}, valid_session
        assigns(:estimate_post).should be_a_new(Estimate::Post)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Estimate::Post.any_instance.stub(:save).and_return(false)
        post :create, {:estimate_post => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested estimate_post" do
        post = Estimate::Post.create! valid_attributes
        # Assuming there are no other estimate_posts in the database, this
        # specifies that the Estimate::Post created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Estimate::Post.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => post.to_param, :estimate_post => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested estimate_post as @estimate_post" do
        post = Estimate::Post.create! valid_attributes
        put :update, {:id => post.to_param, :estimate_post => valid_attributes}, valid_session
        assigns(:estimate_post).should eq(post)
      end

      it "redirects to the estimate_post" do
        post = Estimate::Post.create! valid_attributes
        put :update, {:id => post.to_param, :estimate_post => valid_attributes}, valid_session
        response.should redirect_to(post)
      end
    end

    describe "with invalid params" do
      it "assigns the estimate_post as @estimate_post" do
        post = Estimate::Post.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Estimate::Post.any_instance.stub(:save).and_return(false)
        put :update, {:id => post.to_param, :estimate_post => {}}, valid_session
        assigns(:estimate_post).should eq(post)
      end

      it "re-renders the 'edit' template" do
        post = Estimate::Post.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Estimate::Post.any_instance.stub(:save).and_return(false)
        put :update, {:id => post.to_param, :estimate_post => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested estimate_post" do
      post = Estimate::Post.create! valid_attributes
      expect {
        delete :destroy, {:id => post.to_param}, valid_session
      }.to change(Estimate::Post, :count).by(-1)
    end

    it "redirects to the estimate_posts list" do
      post = Estimate::Post.create! valid_attributes
      delete :destroy, {:id => post.to_param}, valid_session
      response.should redirect_to(estimate_posts_url)
    end
  end

end
