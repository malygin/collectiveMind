require 'spec_helper'
descr ibe 'Discontents ' do
  subject { page }

  before :all do
    @project.update_attribute(:status, 3)

    30.times do
      lp = FactoryGirl.create :discontent, user: @user, project: @project
      lp.aspect = [@aspect1,@aspect2].sample
      lp.style = [0,1].sample
      lp.save
    end
    @post =  FactoryGirl.create :discontent, user: @user, project: @project, content: 'main discontents', aspect: @aspect1, style: 1
  end

  context  'ordinary user sign in ' do
    before { sign_in @user }

    context 'visit post lists' do
      before { visit discontent_posts_path(@project)}


      it {should_not have_selector('li#stage_life_tape.active')}
      it {should have_selector('li#stage_discontent.active')}
      it {should have_selector('li#stage_plan.disabled')}
      it {should have_selector('li#stage_concept.disabled')}

      it_behaves_like 'with mini help' do
        let(:stage){2}
      end

      it_behaves_like 'likable post' do
        let(:voting_model) { Discontent::PostVoting }
        let(:model_path) { discontent_posts_path(@project) }
      end

      it_behaves_like 'filterable post'

      xit 'filter by popularity'


    context 'add post' do
       before { click_link 'add_record'}

       it 'only what field', js: true do
        should have_selector '#send_post.disabled'
        fill_in 'discontent_post_content', with: 'only what field discontent'
        click_button 'send_post'
        should have_selector 'p#discontent_warning'
        expect {
          click_button 'send_post'
          should have_selector 'p#discontent_success'
        }.to change(Discontent::Post, :count).by(1)
      end

      it 'auto complete for where and when', js: true do
          click_link 'when_where_accordion'
          fill_in 'discontent_post_whend', with: 'when'
          find('ul.ui-autocomplete').should have_selector('li', count: 31)
          #should have_selector('ul.ui-autocomplete li')
          #click_button 'send_post'
      end

      xit 'show similar posts for adding '
    end

    context 'edit post' do
      xit 'edit hm'
    end
  end

    context 'show one post' do
      before { visit discontent_post_path(@project, @post)}

      it_behaves_like 'add and like comment' do
        let(:voting_model) { Discontent::CommentVoting }
        let(:model_path) { discontent_post_path(@project, @post) }
      end

      xit 'vote for post'

    end

  end

end