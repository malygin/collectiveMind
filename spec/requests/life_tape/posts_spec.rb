require 'spec_helper'
describe 'Life Tape ' do
  subject { page }
  before :all do
    @project.update_attribute(:status, 1)

    30.times do
      lp = FactoryGirl.create :life_tape_post, user: @user, project: @project
      lp.discontent_aspects << [@aspect1,@aspect2].sample
    end
    @aspects=[]
    4.times { @aspects<< FactoryGirl.create(:aspect, project: @project)}
    @post = FactoryGirl.create :life_tape_post, user: @user, content: 'post from aspect 2', project: @project, created_at: (Time.now.beginning_of_day + 1.day)
    @post.discontent_aspects << @aspect1
  end

  before :each do
    #sign_in @user
    #visit life_tape_posts_path(@project)
  end

  context  'ordinary user sign in ' do

    before do
      lp = FactoryGirl.create :life_tape_post, content: 'low raiting post', user: @user, project: @project, number_views: 1
      lp.discontent_aspects <<@aspect2
      sign_in @user
    end


    context 'visit post lists' do
      before { visit life_tape_posts_path(@project)}

      it_behaves_like 'with mini help' do
        let(:stage){1}
      end


      it {should have_content('life tape post for project')}
      it {should have_selector("form#aspects_list input[type='checkbox']", count: 6)}
      it {should have_selector('div#posts div.media', count: 20)}
      it {should have_selector('ol.breadcrumb li', text:I18n.t('stages.life_tape'))}

      it {should have_selector('li#stage_life_tape.active')}
      it {should have_selector('li#stage_discontent.disabled')}
      it {should have_selector('li#stage_plan.disabled')}
      it {should have_selector('li#stage_concept.disabled')}

      it_behaves_like 'likable post' do
        let(:voting_model) { LifeTape::PostVoting }
        let(:model_path) { life_tape_posts_path(@project) }
      end

      it_behaves_like 'filterable post'

      it 'show  only one aspect', js: true do
        check("aspect_#{@aspect1.id}")
        #click_button('filter-aspect')
        #@todo - bad code ajax response waiting
        first('span.label-info')
        should_not have_selector('span.label-info', text:'aspect 2')
      end

      it 'filter by popularity', js: true  do
        click_link 'date_filter'
        #first('span.label-info')
        should_not have_content 'low raiting post'
      end

      it 'add post', js: true do
        click_link 'add_record'
        fill_in 'new_life_tape', with: 'some text for  new life tape'
        click_button 'send_post'
        #first('span.label-info')
        should have_content 'some text for new life tape'

      end

    end

    context   'visit one post' do
      before { visit life_tape_post_path(@project, @post)}

      it_behaves_like 'add and like comment' do
        let(:voting_model) { LifeTape::CommentVoting }
        let(:model_path) { life_tape_post_path(@project, @post) }
      end

    end

    context 'voting for aspects' do
      before :all do
        @project.update_attribute(:status, 2)
      end

      before { visit life_tape_posts_path(@project)}

      it 'show all aspects for voting' do
          should have_selector("h3.text-danger", text: I18n.t('voting.have_votes'))
          should have_selector(".vote-button", count: @project.aspects.count)
      end

      it 'can not vote for one aspect twice', js: true do
        click_link "vote_#{@aspect1.id}"
        should have_selector("a.disabled#vote_#{@aspect1.id}")
        should have_selector("#count_vote", text: "4")
      end

      it 'vote only 5 times', js: true do
        @aspects.each do |asp|
           click_link "vote_#{asp.id}"
        end
        should_not have_selector(".vote-button")
      end

    end

  end

end