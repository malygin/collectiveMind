# encoding: utf-8
require 'spec_helper'

describe "pages: " do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:project) { FactoryGirl.create(:project, status: 1) }
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

  describe "change stage by admin" do

    it "should not have link for change stage for unknown and ordinary user" do
      visit life_tape_posts_path(project)
      should_not have_css('a#change_stage')
      sign_in user
      visit life_tape_posts_path(project)
      should_not have_css('a#change_stage')
    end

    it "should have link and othe stuff for admin" do
      sign_in admin
      visit life_tape_posts_path(project)
      click_link "change_stage"
      click_link "vote_stage"
      should have_content "Голосование за аспекты"

    end
  end

  describe "vote for aspects" do
    before do
      sign_in admin
      visit life_tape_posts_path(project)
      click_link "change_stage"
      click_link "vote_stage"
       aspect1 = FactoryGirl.create(:aspect, project: project)
       aspect2  = FactoryGirl.create(:aspect, project: project)

    end

    it "should not have opportunity for vote for unknown user" do
      sign_out
      visit life_tape_posts_path(project)
      click_link "vote_stage"
      should_not have_css 'a.voteCounter'

    end
    it "should have opportunity for vote for ordinary user" do
      sign_in user
      visit life_tape_posts_path(project)
      click_link "vote_stage"
      should have_css 'a.voteCounter'
    end

    it "should have normal process of voting" , :js=>true do
      sign_in user
      visit life_tape_posts_path(project)
      click_link "vote_stage"
      should have_content('голосов - 5')
      click_link "aspect_1"
      should_not have_css "a#aspect_1"
      should have_content('голосов - 4')
    end
  end


end


