require 'spec_helper'
describe 'Life Tape Posts' do
  subject { page }

  before :all do
    @user = FactoryGirl.create :user
    @project = FactoryGirl.create :core_project
    @aspect1 = FactoryGirl.create :aspect, project: @project
    @aspect2 = FactoryGirl.create :aspect, project: @project
    30.times do
      lp = FactoryGirl.create :life_tape_post, user: @user, project: @project
      lp.discontent_aspects << [@aspect1,@aspect2].sample
    end
    @post = FactoryGirl.create :life_tape_post, user: @user, project: @project, created_at: (Time.now.beginning_of_day + 1.day)
    @post.discontent_aspects << [@aspect1,@aspect2].sample
  end

  before :each do
    #sign_in @user
    #visit life_tape_posts_path(@project)
  end

  context  'user sign in ' do

    before { sign_in @user }


    context 'visit post lists' do
      before { visit life_tape_posts_path(@project)}

      it {should have_content('life tape post for project')}
      it {should have_selector("form#aspects_list input[type='checkbox']", count: 2)}
      it {should have_selector('div#posts div.media', count: 20)}

      it 'click like on post', js: true do
        expect {
          click_link "post_#{@post.id}"
          should  have_content '1'
          should have_selector("a#post_#{@post.id}.disabled")
        }.to change(LifeTape::PostVoting, :count).by(1)
      end

      xit 'show and save only one aspect'

      xit 'filter by popularity'

    end




  end


end