require 'spec_helper'

describe 'Cabinet Aspects' do
  subject { page }
  let(:cabinet_stage_url) { Rails.application.routes.url_helpers.send("new_#{@current_stage_type_for_cabinet_url}_path", @project, type_mechanic: 'simple') }

  before do
    create_project_and_user_for '1:0'
    @aspect = create :aspect, user: @user, project: @project
    sign_in @user
    visit cabinet_stage_url
  end

  it_behaves_like 'base cabinet'

  context 'create with simple form', js: true do
    before do
      click_link 'new_aspect_posts_simple'
    end

    it 'correct' do
      expect do
        fill_in 'aspect_post_content', with: 'new aspect'
        fill_in 'aspect_post_short_desc', with: 'because'
        click_button 'send_post_aspect'
        expect(page).to have_content t('form.aspect.new_success')
      end.to change(Aspect::Post, :count).by(1)
    end

    it 'empty fields - error' do
      expect do
        click_button 'send_post_aspect'
        within :css, 'div.notice_messages' do
          expect(page).to have_css 'div#error_explanation'
        end
      end.not_to change(Aspect::Post, :count)
    end
  end

  it 'edit', js: true do
    new_content = 'new cool content'
    visit edit_aspect_post_path(@project, @aspect)
    within :css, "form#edit_aspect_post_#{@aspect.id}" do
      expect do
        fill_in 'aspect_post_content', with: new_content
        click_button 'send_post_aspect'
        expect(page).to have_content t('form.aspect.edit_success')
      end.not_to change(Aspect::Post, :count)
    end
    visit edit_aspect_post_path(@project, @aspect)
    within :css, "form#edit_aspect_post_#{@aspect.id}" do
      expect(page).to have_field('aspect_post_content', text: new_content)
    end
  end

  context 'destroy' do
    it 'author - ok', js: true do
      visit user_content_aspect_posts_path(@project)
      expect do
        click_link "destroy_aspect_#{@aspect.id}"
        page.driver.browser.accept_js_confirms
        expect(current_path) == user_content_aspect_posts_path(@project)
      end.to change(Aspect::Post, :count).by(-1)
    end
  end

  it 'created by current user' do
    visit edit_aspect_post_path(@project, @aspect)
    within :css, "form#edit_aspect_post_#{@aspect.id}" do
      expect(page).to have_selector('textarea', text: @aspect.content)
    end
  end

  it 'publish', js: true do
    visit edit_aspect_post_path(@project, @aspect)
    expect do
      click_link "publish_#{@aspect.id}"
      refresh_page
      expect(page).not_to have_link "publish_#{@aspect.id}"
    end.to change(Aspect::Post.published, :count).by(1)
  end
end
