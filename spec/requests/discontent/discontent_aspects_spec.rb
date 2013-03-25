# encoding: utf-8

require 'spec_helper'

describe "Discontent::Aspects" do
  subject {page}
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:project) { FactoryGirl.create(:project) }
  let(:aspect) {FactoryGirl.create(:aspect, project: project)}
  
  describe "GET index" do
    before(:each) do
      visit life_tape_posts_path(project)
    end
    it { should have_selector('h1',    text: 'Список аспектов') }

    it "should have not button for add, delete and edit for unknown user" do
      should_not have_css('a#add_aspect')  
      should_not have_css('a#edit_aspect')
      should_not have_css('a#delete_aspect')
    end 

    it "should have not button for add, delete and edit for ordinary user" do
      sign_in user
      visit life_tape_posts_path(project)
      should_not have_css('a#add_aspect')
      should_not have_css('a#edit_aspect')
      should_not have_css('a#delete_aspect')

    end

    it "should have button for add for boss and add new" do
      sign_in admin
      visit life_tape_posts_path(project)
      should have_css('a#add_aspect')  

      click_link "add_aspect"
      fill_in "discontent_aspect_content",  with: "new aspect"
      expect{
        click_button "Send"
      }.to change(project.aspects, :count).by(1)
      should have_content("new aspect")
    end 

    it "should edit aspect by boss" do
      FactoryGirl.create(:aspect, project: project)
      sign_in admin
      visit life_tape_posts_path(project)
      should have_css('a#edit_aspect')
      click_link "edit_aspect"
      fill_in "discontent_aspect_content", with: "edited aspect"
      click_button "Send"
      should have_content "edited aspect"
    end 

    it "should delete aspect by boss" do
      FactoryGirl.create(:aspect, project: project)

      sign_in admin
      visit life_tape_posts_path(project)
      should have_css('a#delete_aspect')
      expect{
         click_link "delete_aspect"
       }.to change(project.aspects, :count).by(-1)   
    end 

  end


end
