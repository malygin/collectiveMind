require 'spec_helper'
describe 'Life Tape Posts' do
  subject { page }

  before :all do
    @user = FactoryGirl.create :user
    @project = FactoryGirl.create :core_project
    @aspect1 = FactoryGirl.create :aspect, project: @project, content: 'aspect 1'
    @aspect2 = FactoryGirl.create :aspect, project: @project, content: 'aspect 2'
    30.times do
      lp = FactoryGirl.create :life_tape_post, user: @user, project: @project
      lp.discontent_aspects << [@aspect1,@aspect2].sample
    end
    @post = FactoryGirl.create :life_tape_post, user: @user, content: 'post from aspect 2', project: @project, created_at: (Time.now.beginning_of_day + 1.day)
    @post.discontent_aspects << @aspect2
  end

  before :each do
    #sign_in @user
    #visit life_tape_posts_path(@project)
  end

  context  'user sign in ' do

    before {
      lp = FactoryGirl.create :life_tape_post, content: 'low raiting post', user: @user, project: @project, number_views: 1
      lp.discontent_aspects <<@aspect2
      sign_in @user }


    context 'visit post lists' do
      before { visit life_tape_posts_path(@project)}

      xit 'first time show help'

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

      it 'show  only one aspect', js: true do
        check("aspect_#{@aspect1.id}")
        click_button('filter-aspect')
        #@todo - bad code ajax response waiting
        first('span.label-info')
        should_not have_selector('span.label-info', text:'aspect 2')
      end

      it 'show  only one aspect', js: true do
        should_not have_selector('span.label-info', text:'aspect 2')
      end

      it 'filter by popularity', js: true  do
        click_link 'date_filter'
        first('span.label-info')
        should_not have_content 'low raiting post'
      end

      xit 'add post'
      xit 'can not like post twice'
    end

    context   'visit one post' do
      xit 'like post and can not like post twice'
      xit 'add comment'
    end




  end


end