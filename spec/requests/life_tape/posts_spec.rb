require 'spec_helper'
describe 'Life Tape ' do
  subject { page }

  before :all do
    @user = FactoryGirl.create :user
    @project = FactoryGirl.create :core_project
    @aspect1 = FactoryGirl.create :aspect, project: @project, content: 'aspect 1'
    @aspect2 = FactoryGirl.create :aspect, project: @project, content: 'aspect 2'
    (1..1).each do |i|
      (1..3).each do |j|
        FactoryGirl.create :help_post, stage: i, style: j
      end
      post_mini_1 = FactoryGirl.create :help_post, stage: i, mini: true
      @question_mini  = FactoryGirl.create :help_question, post: post_mini_1
      @answer_mini = FactoryGirl.create :help_answer, help_question:@question_mini
      3.times{ FactoryGirl.create :help_answer, help_question:@question_mini }
    end
    30.times do
      lp = FactoryGirl.create :life_tape_post, user: @user, project: @project
      lp.discontent_aspects << [@aspect1,@aspect2].sample
    end
    @aspects=[]
    4.times { @aspects<< FactoryGirl.create(:aspect, project: @project)}

    @post = FactoryGirl.create :life_tape_post, user: @user, content: 'post from aspect 2', project: @project, created_at: (Time.now.beginning_of_day + 1.day)
    @post.discontent_aspects << @aspect2
  end

  before :each do
    #sign_in @user
    #visit life_tape_posts_path(@project)
  end

  context  'user sign in ' do

    before do
      lp = FactoryGirl.create :life_tape_post, content: 'low raiting post', user: @user, project: @project, number_views: 1
      lp.discontent_aspects <<@aspect2
      sign_in @user
    end


    context 'visit post lists' do
      before { visit life_tape_posts_path(@project)}

        it 'first time show help' , js: true  do
          should have_selector("h4#helpModalLabel.modal-title", visible: true)
          should have_selector("button.disabled#send", visible: true)
        end

        it 'answer on mini help question ', js: true do
          choose("question[#{@question_mini.id}][#{@answer_mini.id}]")
          click_button 'send'
          first('span.label-info')
          should have_selector("h4#helpModalLabel.modal-title", visible: false)
        end

        it 'did not show mini help  after answering', js: true do
          should_not have_selector("h4#myModalLabel.modal-title")
        end


      it {should have_content('life tape post for project')}
      it {should have_selector("form#aspects_list input[type='checkbox']", count: 6)}
      it {should have_selector('div#posts div.media', count: 20)}
      it {should have_selector("ol.breadcrumb li", text:I18n.t('stages.life_tape'))}


      it 'click like on post', js: true do
        expect {
          click_link "plus_post_#{@post.id}"
          should  have_content '1'
          should have_selector("a#plus_post_#{@post.id}.disabled")
        }.to change(LifeTape::PostVoting, :count).by(1)
        visit life_tape_posts_path(@project)
        should_not have_selector("a#plus_post_#{@post.id}")
      end


      it 'show  only one aspect', js: true do
        check("aspect_#{@aspect1.id}")
        click_button('filter-aspect')
        #@todo - bad code ajax response waiting
        first('span.label-info')
        should_not have_selector('span.label-info', text:'aspect 2')
      end

      it 'show  only one aspect' do
        should_not have_selector('span.label-info', text:'aspect 2')
      end

      it 'filter by popularity', js: true  do
        click_link 'date_filter'
        first('span.label-info')
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

      it 'add comment', js: true do
        should have_selector("input.disabled#send_post")
        fill_in 'comment_text_area', with: 'some text for comment'
        should_not have_selector("input.disabled#send_post")
        click_button 'send_post'
        should have_content 'some text for comment'
      end

      it 'like comment only one time', js:true do
          comment = @post.comments.first
          expect {
            click_link "plus_comment_#{comment.id}"
            should  have_selector("span#counter_comment_#{comment.id}")
            should have_selector("a#plus_comment_#{comment.id}.disabled")
          }.to change(LifeTape::CommentVoting, :count).by(1)
          visit life_tape_post_path(@project, @post)
          should_not have_selector("a#plus_comment_#{comment.id}")
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