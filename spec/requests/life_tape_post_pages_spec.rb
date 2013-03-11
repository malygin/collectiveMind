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
      should_not have_css('a#add_record')  
    end

    it "should create new post if user sign in" do
      sign_in user
      visit life_tape_posts_path(project)
      click_link "add_record"
      fill_in "life_tape_post_content",  with: "new foo"
      expect{
        click_button "Send"
      }.to change(project.life_tape_posts, :count).by(1)
      should have_content("new foo")
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
      visit life_tape_post_path(project, post)
      should_not have_selector('form#new_life_tape_comment')
    end

    it "should leave a comment if sign_in " do
      sign_in user
      visit life_tape_post_path(project, post)
      fill_in "life_tape_comment_content",  with: "foo"
      expect{
         click_button "Send"
       }.to change(post.comments, :count).by(1)        
      should have_content("foo")
    end
  end

  describe "edit  post" do
    
    it "should by owner" do
      sign_in user
      visit life_tape_post_path( project, post)
      click_link "edit_post"
      # puts page.body
      fill_in "life_tape_post_content", with: "woo-hoo"
      click_button "Send"
      current_path.should == life_tape_post_path(project, post)
      should have_content "woo-hoo"
    end

  end



end


