# encoding: utf-8
require 'spec_helper'

describe "pages: " do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:project) { FactoryGirl.create(:project) }

  before(:all) { 10.times {   
      FactoryGirl.create(:life_tape_post, user: user, project: project) }}
  before(:all) { 15.times {   
      FactoryGirl.create(:life_tape_post, user: user, project: project) }}
  
  describe "GET index" do
    before(:each) do
      visit life_tape_posts_path(project)
    end
    it { should have_selector('h1',    text: 'Список аспектов') }

    it "should have not button for add" do
      should_not have_content("add_record.png")
    end
    it "should have  button for add if user sign in" do
      sign_in user
      visit life_tape_posts_path(project)
      should have_content("add_record.png")
    end

  end

  describe "get show post" do
    subject { page }
    let(:post){FactoryGirl.create(:life_tape_post, user: user, project: project)}
    before(:each){
      visit life_tape_post_path(project, post)}

    it {  should have_selector("title")}

  end

end


