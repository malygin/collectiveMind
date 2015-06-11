require 'spec_helper'

describe 'Cabinet Plans' do
  subject { page }
  let(:cabinet_stage_url) { Rails.application.routes.url_helpers.send("new_#{@current_stage_type_for_cabinet_url}_path", @project, type_mechanic: 'simple') }

  before do
    create_project_and_user_for '5:0'
    @plan = create :plan, user: @user, project: @project
    sign_in @user
    visit cabinet_stage_url
  end

  it_behaves_like 'base cabinet'

  context 'create with simple form', js: true do
    before do
      click_link 'new_plan_posts_simple'
    end

    it 'correct' do
      expect {
        fill_in 'plan_post_novation_project_goal', with: 'new plan'
        click_button 'to_save_plan'
        expect(page).to have_content t('form.plan.new_success')
      }.to change(Plan::Post, :count).by(1)
    end

    it 'empty fields - error' do
      expect {
        click_button 'to_save_plan'
        expect(page).to have_css 'div#error_explanation'
      }.not_to change(Plan::Post, :count)
    end
  end

  it 'edit', js: true do
    new_content = 'new cool content'
    visit user_content_plan_posts_path(@project)
    find(:css, "#edit_plan_#{@plan.id}").trigger('click')
    expect {
      fill_in 'plan_post_content', with: new_content
      click_button 'to_save_plan'
      expect(page).to have_content t('form.plan.edit_success')
    }.not_to change(Plan::Post, :count)
    visit user_content_plan_posts_path(@project)
    expect(page).to have_content new_content
  end

  context 'destroy' do
    it 'author - ok', js: true do
      visit user_content_plan_posts_path(@project)
      expect {
        execute_script("$('#destroy_plan_#{@plan.id}').click()")
        page.driver.browser.accept_js_confirms
        expect(current_path) == user_content_plan_posts_path(@project)
      }.to change(Plan::Post, :count).by(-1)
    end
  end

  it 'created by current user' do
    click_link 'user_content_plan_posts'
    expect(page).to have_content @plan.content
  end

  it 'publish', js: true do
    visit edit_plan_post_path(@project, @plan)
    expect {
      click_button 'to_publish_plan'
      refresh_page
      expect(page).to have_css 'img.publish'
      expect(page).not_to have_button 'to_publish_plan'
    }.to change(Plan::Post.published, :count).by(1)
  end
end
