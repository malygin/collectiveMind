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
    @comment = FactoryGirl.create :life_tape_comment, content: 'comment for post', user: @user, post: @post
  end

  before :each do
    #sign_in @user
    #visit life_tape_posts_path(@project)
  end

  context  'ordinary user sign in ' do

    before do
      lp = FactoryGirl.create :life_tape_post, content: 'low raiting post', user: @user, project: @project, number_views: 1
      lp.discontent_aspects << @aspect2
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

      #it_behaves_like 'likable post' do
      #  let(:voting_model) { LifeTape::PostVoting }
      #  let(:model_path) { life_tape_posts_path(@project) }
      #end

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
        fill_in 'new_life_tape', with: 'some text for new life tape'
        click_button 'send_post'
        first('span.label-info')
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

    context 'comments for post' do
      before do
        visit life_tape_post_path(@project, @post)
      end

      it {should have_selector 'form#new_life_tape_comment'}
      it {should have_content 'comment for post'}
      it {should have_selector("div#comment_#{@comment.id}")}
      it {should have_selector("div#redactor_comment_#{@comment.id}")}

      it 'new comment', js: true do
        should have_selector '#send_post.disabled'
        fill_in 'comment_text_area', with: 'some text for new comment life tape'
        should_not have_selector '#send_post.disabled'
        click_button "send_post"
        should have_content 'some text for new comment life tape'
      end

      it 'edit comment', js: true do
        click_link "edit_comment_#{@comment.id}"
        should have_selector("form#edit_life_tape_comment_#{@comment.id}")
        should_not have_selector("div#redactor_comment_#{@comment.id}", visible: true)
        fill_in 'edit_comment_text_area', with: 'some text for edit comment life tape'
        click_button "send_post_#{@comment.id}"
        should have_content 'some text for edit comment life tape'
        should have_selector("div#redactor_comment_#{@comment.id}", visible: true)
      end

      it 'delete comment', js: true do
        #page.driver.browser.switch_to.alert.accept
        expect {
          click_link "destroy_comment_#{@comment.id}"
          page.driver.browser.switch_to.alert.accept
          sleep 1.5
          should_not have_selector("div#comment_#{@comment.id}")
        }.to change(LifeTape::Comment, :count).by(-1)
      end
    end
  end

  context 'work with aspects ' do
    before :all do
      @project.update_attribute(:status, 1)
      sign_out
    end
    before do
      sign_in @admin
      visit life_tape_posts_path(@project)
    end

    it 'new aspect', js: true do
      click_link 'new_aspect'
      should have_selector 'div#modal_aspect_view'
      fill_in 'aspect_text_area', with: 'new aspect life tape'
      expect {
      click_button "send_post"
      should have_content 'new aspect life tape'
      }.to change(Discontent::Aspect, :count).by(1)
    end
    it 'edit aspect', js: true do
      click_link "edit_aspect_#{@aspect1.id}"
      should have_selector('div#modal_aspect_view', visible: true)
      should have_selector('#aspect_text_area', 'aspect 1')
      fill_in 'aspect_text_area', with: 'update aspect life tape'
      click_button "send_post"
      should have_selector("div#edit_aspect_content_#{@aspect1.id}", text:"update aspect life tape (#{@aspect1.life_tape_posts.count})")
    end
    #@todo help
    it 'delete aspect', js: true do
      expect {
        click_link "destroy_aspect_#{@aspect1.id}"
        page.driver.browser.switch_to.alert.accept
        sleep 1.5
        should_not have_selector("div#aspect_checkbox_#{@aspect1.id}")
      }.to change(Discontent::Aspect, :count).by(-1)
    end

  end


end