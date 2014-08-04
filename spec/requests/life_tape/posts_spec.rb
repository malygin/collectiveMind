require 'spec_helper'
describe 'Life Tape ' do
  subject { page }

  before  do
    @project = FactoryGirl.create :core_project, :status => 1
    @aspect1 = FactoryGirl.create :aspect, project: @project, content: 'aspect 1'
    @aspect2 = FactoryGirl.create :aspect, project: @project, content: 'aspect 2'
  end

  context  'ordinary user sign in ' do
    before do
      @user = FactoryGirl.create :user
      sign_in @user
    end
     it ' view comments list in aspect', js: true do
       # screenshot_and_open_image
       click_link 'go_to_project'
       click_link 'to_work'
     end

  end

  context 'moderator sign in' do
  end

  context 'expert sign in' do
  end

end