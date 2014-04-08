require 'spec_helper'
describe 'Discontents ' do
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
    @union_post =  FactoryGirl.create :discontent_union, project: @project, whend: 'whendispost', whered: 'wheredispost', aspect: @aspect1, style: 1
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
          execute_script %Q{ $('#discontent_post_whend').trigger("focus") }
          execute_script %Q{ $('#discontent_post_whend').trigger("keydown") }
          should have_selector('ul.ui-autocomplete li')

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

  context  'union posts ' do
    before :all do
      @project.update_attribute(:status, 4)
      @post_for_union_user =  FactoryGirl.create :discontent, user: @user, project: @project, content: 'discontent for union', whend: 'testwhen', whered: 'testwhere', aspect: @aspect1, status: 0, style: 1
      3.times do
        dpu = FactoryGirl.create :discontent, user: @user, project: @project, whend: 'testwhen', whered: 'testwhere', aspect: @aspect1, status: 0, style: 1
        dpu.save
      end
      @post_for_union = FactoryGirl.create :discontent, user: @user, project: @project, whend: 'whendispost', whered: 'wheredispost', aspect: @aspect1, status: 1, style: 1, "discontent_post_id" => @union_post.id
      3.times do
        dp = FactoryGirl.create :discontent, user: @user, project: @project, whend: 'whendispost', whered: 'wheredispost', aspect: @aspect1, status: 1, "discontent_post_id" => @union_post.id
        dp.style = [0,1].sample
        dp.save
      end
    end
    before do
      sign_in @admin
      visit discontent_posts_path(@project)
    end

    context 'union disposts' do
      it 'create one union dispost', js: true do
        expect {
          execute_script %Q{ $('#post_#{@post_for_union_user.id}').find('.content').trigger("click") }
          should have_selector("#post_#{@post_for_union_user.id}")
          should have_selector('div.media', count: 4)
          click_button 'btn-union'
        }.to change(Discontent::Post, :count).by(1)
      end
    end
    context 'union disposts remove' do
      before do
        visit discontent_post_path(@project,@union_post)
      end
      #before js: true do
      #  execute_script %Q{ $('li#new a').trigger("click") }
      #  execute_script %Q{ $('div.content').trigger("click") }
      #end
      it 'remove one union dispost', js: true do
        should have_selector("#post_#{@union_post.id}")
        should have_selector("#url_post_#{@post_for_union.id}")
        should have_selector('div.media', count: 5)
        find("#url_post_#{@post_for_union.id} a").click
        sleep 1.5
        should_not have_selector("#post_#{@post_for_union.id}")
      end

    end

  end

end