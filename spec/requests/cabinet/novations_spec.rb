require 'spec_helper'

describe 'Cabinet Novations' do
  subject { page }
  let (:project) { create :core_project, status: Core::Project::STATUS_CODES[:novation] }
  let (:core_project_user) { create :core_project_user, core_project: project }
  let (:user) { core_project_user.user }
  let! (:novation) { create :novation, user: user, project: project }

  before do
    technique_1 = Technique::List.create stage: 'novation_posts', code: 'simple'
    project.techniques << technique_1

    sign_in user
    visit project_user_path(project, user)
  end

  it 'correct link to cabinet' do
    click_link 'open_cabinet'
    expect(current_path) == new_novation_post_path(project, type_mechanic: 'simple')
  end

  it 'list forms for techniques' do
    project.techniques.each do |technique|
      expect(page).to have_content t("techniques.#{technique.name}")
    end
  end

  xit 'close sticker' do
    expect(page).to have_content t('cabinet.novation_posts_sticker')
    expect {
      click_link 'close_sticker'
    }.to change(UserCheck, :count).by(1)
    refresh_page
    expect(page).not_to have_content t('cabinet.novation_posts_sticker')
  end

  context 'create with simple form', js: true do
    before do
      click_link 'new_novation_posts_simple'
    end

    xit 'correct' do
      expect {
        fill_in 'novation_post_title', with: 'new novation'
        click_button 'send_post_novation'
        expect(page).to have_content t('form.novation.new_success')
      }.to change(Novation::Post, :count).by(1)
    end

    xit 'empty fields - error' do
      expect {
        click_button 'send_post_novation'
        within :css, 'div.notice_messages' do
          expect(page).to have_css 'div#error_explanation'
        end
      }.not_to change(Novation::Post, :count)
    end
  end

  xit 'edit', js: true do
    new_content = 'new cool content'
    visit user_content_novation_posts_path(project)
    click_link "edit_novation_#{novation.id}"
    expect {
      fill_in 'novation_post_title', with: new_content
      click_button 'send_post_novation'
      expect(page).to have_content t('form.novation.edit_success')
    }.not_to change(Novation::Post, :count)
    visit user_content_novation_posts_path(project)
    expect(page).to have_content new_content
  end

  context 'destroy' do
    it 'author - ok', js: true do
      visit user_content_novation_posts_path(project)
      expect {
        click_link "destroy_novation_#{novation.id}"
        page.driver.browser.accept_js_confirms
        expect(current_path) == user_content_novation_posts_path(project)
      }.to change(Novation::Post, :count).by(-1)
    end
  end

  it 'created by current user' do
    click_link 'open_my_novation_posts'
    expect(page).to have_content novation.content
  end

  xit 'publish', js: true do
    visit edit_novation_post_path(project, novation)
    click_link "publish_#{novation.id}"
    refresh_page
    expect(page).not_to have_link "publish_#{novation.id}"
  end
end
