# encoding: utf-8
require 'spec_helper'

describe "pages: " do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:project) { FactoryGirl.create(:project) }
  let(:post){FactoryGirl.create(:life_tape_post, user: user, project: project)}
  let(:post_admin){FactoryGirl.create(:life_tape_post, user: admin, project: project)}
  
  # before(:all) { 10.times {   
  #     FactoryGirl.create(:life_tape_post, user: user, project: project) }}
  # before(:all) { 15.times {   
  #     FactoryGirl.create(:life_tape_post, user: user, project: project) }}
  
  describe "GET index" do
    before(:each) do
      visit life_tape_posts_path(project)
    end
    it { should have_selector('h1',    text: 'Список аспектов') }

    it "should have not button for add" do
      should_not have_content("add_record")
    end
    it "should have  button for add if user sign in" do
      sign_in user
      visit life_tape_posts_path(project)
      should have_content("add_record")
    end

  end

  describe "get show post" do
    it "should have edit link if his post" do
      sign_in user
      visit life_tape_post_path(project, post)
      should have_content("Edit")
    end 
    it "should have not edit link if  post from another user" do
      sign_in user

      visit life_tape_post_path(project, post_admin)
      should_not have_content("Edit")
    end

    it "should not leave a comment if not sign_in" do
      # let(:post){FactoryGirl.create(:life_tape_post, user: user, project: project)}

      visit life_tape_post_path(project, post)
      should_not have_selector('form#new_life_tape_comment')
    end
  end

end


