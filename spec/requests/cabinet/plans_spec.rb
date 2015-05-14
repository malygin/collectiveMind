require 'spec_helper'

describe 'Cabinet Plans' do
  subject { page }
  let(:cabinet_stage_url) { Rails.application.routes.url_helpers.send("new_#{@project.current_stage_type_for_cabinet_url}_path", @project, type_mechanic: 'simple') }

  before do
    create_project_and_user_for :plan
    @plan = create :plan, user: @user, project: @project
    sign_in @user
    visit cabinet_stage_url
  end

  it_behaves_like 'base cabinet'

  context 'create with simple form', js: true do
    before do
      click_link 'new_plan_posts_simple'
    end

    xit 'correct' do
      expect {
        fill_in 'plan_post_title', with: 'new plan'
        click_button 'send_post_plan'
        expect(page).to have_content t('form.plan.new_success')
      }.to change(Plan::Post, :count).by(1)
    end

    xit 'empty fields - error' do
      expect {
        click_button 'send_post_plan'
        within :css, 'div.notice_messages' do
          expect(page).to have_css 'div#error_explanation'
        end
      }.not_to change(Plan::Post, :count)
    end
  end

  xit 'edit', js: true do
    new_content = 'new cool content'
    visit user_content_plan_posts_path(project)
    click_link "edit_plan_#{plan.id}"
    expect {
      fill_in 'plan_post_title', with: new_content
      click_button 'send_post_plan'
      expect(page).to have_content t('form.plan.edit_success')
    }.not_to change(Plan::Post, :count)
    visit user_content_plan_posts_path(project)
    expect(page).to have_content new_content
  end

  context 'destroy' do
    it 'author - ok', js: true do
      visit user_content_plan_posts_path(project)
      expect {
        click_link "destroy_plan_#{plan.id}"
        page.driver.browser.accept_js_confirms
        expect(current_path) == user_content_plan_posts_path(project)
      }.to change(Plan::Post, :count).by(-1)
    end
  end

  it 'created by current user' do
    click_link 'open_my_plan_posts'
    expect(page).to have_content plan.content
  end

  xit 'publish', js: true do
    visit edit_plan_post_path(project, plan)
    click_link "publish_#{plan.id}"
    refresh_page
    expect(page).not_to have_link "publish_#{plan.id}"
  end
end
