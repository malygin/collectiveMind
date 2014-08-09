# encoding: utf-8
require 'spec_helper'
describe 'Knowbase ' do
  subject { page }

  let (:user) {create :user }
  let (:admin) {create :admin }
  let (:project) {create :core_project, status: 1 }

  before do
    @post1 =  FactoryGirl.create :knowbase_post, project: project, title: 'title first knowbase', content: 'content first knowbase', stage: 1
    @post2 =  FactoryGirl.create :knowbase_post, project: project, title: 'title second knowbase', content: 'content second knowbase', stage: 2
  end


  context  'knowbase post view sign in user ' do
    before do
      sign_in user
      visit knowbase_posts_path(project)
    end

    context 'visit knowbase posts as user' do
      it ' has all tags' do
        expect have_selector("span#edit_knowbase_post_title_#{@post1.id}", @post1.title)
        expect have_selector("div#edit_knowbase_post_content_#{@post1.id}", @post1.content)
        expect(page).to_not have_selector('ul#sortable li')
        expect(page).to_not have_selector('li.ui-state-default')
        expect(page).to_not have_selector('a#new_knowbase_post')
        expect(page).to_not have_selector("a#edit_knowbase_post_#{@post1.id}")
        expect(page).to_not have_selector("a#destroy_knowbase_post_#{@post1.id}")
        expect have_selector("li##{@post1.id}.active")
        expect(page).to_not have_selector("li##{@post2.id}.active")
      end
    end
    context 'visit knowbase post 2' do
      before { visit knowbase_post_path(project,@post2) }
      it ' has all tags' do
        expect have_selector("span#edit_knowbase_post_title_#{@post2.id}", @post1.title)
        expect have_selector("div#edit_knowbase_post_content_#{@post2.id}", @post1.content)
        expect(page).to_not have_selector("li##{@post1.id}.active")
        expect have_selector("li##{@post2.id}.active")
      end
    end
  end

  context  'knowbase post view sign in admin ' do
    before do
      sign_in admin
      visit knowbase_posts_path(project)
    end

    context 'visit knowbase posts as admin' do
      it ' has all tags' do
        expect have_selector("span#edit_knowbase_post_title_#{@post1.id}", @post1.title)
        expect have_selector("div#edit_knowbase_post_content_#{@post1.id}", @post1.content)
        expect have_selector('ul#sortable li')
        expect have_selector('li.ui-state-default')
        expect have_selector('a#new_knowbase_post')
        expect have_selector("a#edit_knowbase_post_#{@post1.id}")
        expect have_selector("a#destroy_knowbase_post_#{@post1.id}")
        expect have_selector("li##{@post1.id}.active")
        expect(page).to_not have_selector("li##{@post2.id}.active")
      end

      context 'add knowbase post' do
        before { click_link "new_knowbase_post" }
        it 'post without content' do
          expect have_selector("ul.wysihtml5-toolbar")
          expect have_selector '#send_post.disabled'
          fill_in 'title-textfield', with: 'title'
          expect have_content("Заполните поле контента")
          expect(page).to_not have_selector '#send_post.disabled'
        end
        #@todo not focus on editor when set value(not work activate_button)
        #it 'post with content', js:true do
        #  fill_in_wysihtml5('some-textarea', with: 'content for post')
        #end
        #it ' add post with content' do
        #  fill_in 'title-textfield', with: 'title for post'
        #  #fill_in_wysihtml5('some-textarea', with: 'content for post')
        #  #execute_script %Q{ $('.wysihtml5-editor').trigger("focus") }
        #  #execute_script %Q{ $('.wysihtml5-editor').trigger("keyup") }
        #  expect(page).to_not have_selector '#send_post.disabled'
        #  expect {
        #    click_button "send_post"
        #    expect have_content 'title for post'
        #    expect have_content 'content for post'
        #  }.to change(Knowbase::Post, :count).by(1)
        #end
      end
      context 'edit knowbase post' do
        before { click_link "edit_knowbase_post_#{@post1.id}" }

        it 'content and title', js: true do
          expect have_selector("ul.wysihtml5-toolbar")
          expect have_selector("input#title-textfield", @post1.title)
          fill_in 'title-textfield', with: 'new title'
          click_button 'send_post'
          expect have_selector("span#edit_knowbase_post_title_#{@post1.id}", 'new title')
        end
      end
      context 'delete knowbase post' do
        it 'delete and redirect' do
          expect {
            click_link "destroy_knowbase_post_#{@post1.id}"
            expect(page).to_not have_selector("span#edit_knowbase_post_title_#{@post1.id}")
            expect have_selector("span#edit_knowbase_post_title_#{@post2.id}", @post2.title)
          }.to change(Knowbase::Post, :count).by(-1)
        end
      end
    end
  end
end
