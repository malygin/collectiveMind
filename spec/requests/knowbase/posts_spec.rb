require 'spec_helper'

describe 'Knowbase ', skip: true do
  subject { page }

  let (:user) { create :user }
  let (:moderator) { create :moderator }
  let (:project) { create :core_project }

  before do
    @post1 = create :knowbase_post, project: project
    @post2 = create :knowbase_post, project: project
    @aspect1 = create :aspect, project: project
    @aspect2 = create :aspect, project: project
  end

  context 'sign in user' do
    before do
      sign_in user
      visit knowbase_posts_path(project)
    end

    context 'visit knowbase posts' do
      it ' has all tags' do
        expect(page).to have_selector("span#edit_knowbase_post_title_#{@post1.id}", @post1.title)
        expect(page).to have_selector("div#edit_knowbase_post_content_#{@post1.id}", @post1.content)
        expect(page).to_not have_selector('ul#sortable li')
        expect(page).to_not have_selector('li.ui-state-default')
        expect(page).to_not have_selector('a#new_knowbase_post')
        expect(page).to_not have_selector("a#edit_knowbase_post_#{@post1.id}")
        expect(page).to_not have_selector("a#destroy_knowbase_post_#{@post1.id}")
        expect(page).to have_selector("li##{@post1.id}.active")
        expect(page).to_not have_selector("li##{@post2.id}.active")
      end
    end

    context 'show knowbase post' do
      before do
        visit knowbase_post_path(project, @post2)
      end

      it ' has all tags' do
        expect(page).to have_selector("span#edit_knowbase_post_title_#{@post2.id}", @post1.title)
        expect(page).to have_selector("div#edit_knowbase_post_content_#{@post2.id}", @post1.content)
        expect(page).to_not have_selector("li##{@post1.id}.active")
        expect(page).to have_selector("li##{@post2.id}.active")
      end
    end
  end

  context 'sign in moderator' do
    before do
      sign_in moderator
      visit knowbase_posts_path(project)
    end

    context 'visit knowbase posts as admin' do
      it ' has all tags' do
        expect(page).to have_selector("span#edit_knowbase_post_title_#{@post1.id}", @post1.title)
        expect(page).to have_selector("div#edit_knowbase_post_content_#{@post1.id}", @post1.content)
        expect(page).to have_selector('ul#sortable li')
        expect(page).to have_selector('li.ui-state-default')
        expect(page).to have_selector('a#new_knowbase_post')
        expect(page).to have_selector("a#edit_knowbase_post_#{@post1.id}")
        expect(page).to have_selector("a#destroy_knowbase_post_#{@post1.id}")
        expect(page).to have_selector("li##{@post1.id}.active")
        expect(page).to_not have_selector("li##{@post2.id}.active")
      end

      context 'edit knowbase post' do
        before do
          click_link "edit_knowbase_post_#{@post1.id}"
        end

        it 'content and title', js: true do
          expect(page).to have_selector("input#title-textfield", @post1.title)
          fill_in 'title-textfield', with: 'new title'
          click_button 'send_post'
          sleep 5
          expect(page).to have_selector("span#edit_knowbase_post_title_#{@post1.id}", 'new title')
        end
      end

      context 'delete knowbase post' do
        it 'delete and redirect' do
          expect {
            click_link "destroy_knowbase_post_#{@post1.id}"
            expect(page).to_not have_selector("span#edit_knowbase_post_title_#{@post1.id}")
            expect(page).to have_selector("span#edit_knowbase_post_title_#{@post2.id}", @post2.title)
          }.to change(Knowbase::Post, :count).by(-1)
        end
      end
    end
  end
end
