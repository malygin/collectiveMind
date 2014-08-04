require 'spec_helper'
describe 'Knowbase ' do
  subject { page }

  before do
    @post1 =  FactoryGirl.create :knowbase_post, project: @project, title: 'title first knowbase', content: 'content first knowbase', stage: 1
    @post2 =  FactoryGirl.create :knowbase_post, project: @project, title: 'title second knowbase', content: 'content second knowbase', stage: 2
  end


  context  'knowbase post view sign in user ' do
    before do
      sign_in @user
      visit knowbase_posts_path(@project)
    end

    context 'visit knowbase posts as user' do
      it { should have_selector("span#edit_knowbase_post_title_#{@post1.id}", @post1.title) }
      it { should have_selector("div#edit_knowbase_post_content_#{@post1.id}", @post1.content) }
      it { should_not have_selector('ul#sortable li') }
      it { should_not have_selector('li.ui-state-default') }
      it { should_not have_selector('a#new_knowbase_post') }
      it { should_not have_selector("a#edit_knowbase_post_#{@post1.id}") }
      it { should_not have_selector("a#destroy_knowbase_post_#{@post1.id}") }
      it { should have_selector("li##{@post1.id}.active") }
      it { should_not have_selector("li##{@post2.id}.active") }
    end
    context 'visit knowbase post 2' do
      before { visit knowbase_post_path(@project,@post2) }

      it { should have_selector("span#edit_knowbase_post_title_#{@post2.id}", @post1.title) }
      it { should have_selector("div#edit_knowbase_post_content_#{@post2.id}", @post1.content) }
      it { should_not have_selector("li##{@post1.id}.active") }
      it { should have_selector("li##{@post2.id}.active") }
    end
  end

  context  'knowbase post view sign in admin ' do
    before do
      sign_in @admin
      visit knowbase_posts_path(@project)
    end

    context 'visit knowbase posts as admin' do
      it { should have_selector("span#edit_knowbase_post_title_#{@post1.id}", @post1.title) }
      it { should have_selector("div#edit_knowbase_post_content_#{@post1.id}", @post1.content) }
      it { should have_selector('ul#sortable li') }
      it { should have_selector('li.ui-state-default') }
      it { should have_selector('a#new_knowbase_post') }
      it { should have_selector("a#edit_knowbase_post_#{@post1.id}") }
      it { should have_selector("a#destroy_knowbase_post_#{@post1.id}") }
      it { should have_selector("li##{@post1.id}.active") }
      it { should_not have_selector("li##{@post2.id}.active") }

      context 'add knowbase post' do
        before { click_link "new_knowbase_post" }
        it 'post without content', js: true do
          should have_selector("ul.wysihtml5-toolbar")
          should have_selector '#send_post.disabled'
          fill_in 'title-textfield', with: 'title'
          should_not have_selector '#send_post.disabled'
        end
        #@todo not focus on editor when set value(not work activate_button)
        it 'post with content', js: true do
          fill_in 'title-textfield', with: 'title for post'
          fill_in_wysihtml5('some-textarea', with: 'content for post')
          #execute_script %Q{ $('.wysihtml5-editor').trigger("focus") }
          #execute_script %Q{ $('.wysihtml5-editor').trigger("keyup") }
          should_not have_selector '#send_post.disabled'
          expect {
            click_button "send_post"
            should have_content 'title for post'
            should have_content 'content for post'
          }.to change(Knowbase::Post, :count).by(1)
        end
      end
      context 'edit knowbase post' do
        before { click_link "edit_knowbase_post_#{@post1.id}" }

        it 'content and title', js: true do
          should have_selector("ul.wysihtml5-toolbar")
          should have_selector("input#title-textfield", @post1.title)
          fill_in 'title-textfield', with: 'new title'
          click_button 'send_post'
          should have_selector("span#edit_knowbase_post_title_#{@post1.id}", 'new title')
        end
      end
      context 'delete knowbase post' do
        it 'delete and redirect' do
          expect {
            click_link "destroy_knowbase_post_#{@post1.id}"
            should_not have_selector("span#edit_knowbase_post_title_#{@post1.id}")
            should have_selector("span#edit_knowbase_post_title_#{@post2.id}", @post2.title)
          }.to change(Knowbase::Post, :count).by(-1)
        end
      end
    end
  end
end
