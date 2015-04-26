require 'rake'
require 'spec_helper'

describe 'Cabinet Aspects' do
  subject { page }
  let (:project) { create :core_project, status: Core::Project::STATUS_CODES[:collect_info] }
  let (:core_project_user) { create :core_project_user, core_project: project }
  let (:user) { core_project_user.user }
  let! (:aspect) { create :aspect, user: user, project: project }

  before do
    # тут еще нужно прицеплять техники к проекту
    #Rake::Task['seed:migrate'].invoke
    technique_1 = Technique::List.create stage: 'aspect_posts', code: 'simple'
    project.techniques << technique_1

    sign_in user
    visit project_user_path(project, user)
  end

  it 'correct link to cabinet' do
    click_link 'open_cabinet'
    expect(current_path) == new_aspect_post_path(project, type_mechanic: 'simple')
  end

  it 'list forms for techniques' do
    project.techniques.each do |technique|
      expect(page).to have_content t("techniques.#{technique.name}")
    end
  end

  it 'close sticker' do
    expect(page).to have_content t('cabinet.collect_info_posts_sticker')
    expect {
      click_link 'close_sticker'
    }.to change(UserCheck, :count).by(1)
    refresh_page
    expect(page).not_to have_content t('cabinet.collect_info_posts_sticker')
  end

  context 'create with simple form', js: true do
    before do
      click_link 'new_aspect_posts_simple'
    end

    it 'correct' do
      expect {
        fill_in 'core_aspect_post_content', with: 'new aspect'
        fill_in 'core_aspect_post_short_desc', with: 'because'
        click_button 'send_post_aspect'
        expect(page).to have_content t('form.aspect.new_success')
      }.to change(Core::Aspect::Post, :count).by(1)
    end

    it 'empty fields - error' do
      expect {
        fill_in 'core_aspect_post_content', with: ''
        fill_in 'core_aspect_post_short_desc', with: ''
        click_button 'send_post_aspect'
        within :css, 'div#notice_messages' do
          expect(page).to have_css 'div#error_explanation'
        end
      }.not_to change(Core::Aspect::Post, :count)
    end
  end

  it 'edit', js: true do
    new_content = 'new cool content'
    visit user_content_collect_info_posts_path(project)
    click_link "edit_aspect_#{aspect.id}"
    expect {
      fill_in 'core_aspect_post_content', with: new_content
      click_button 'send_post_aspect'
      expect(page).to have_content t('form.aspect.edit_success')
    }.not_to change(Core::Aspect::Post, :count)
    visit user_content_collect_info_posts_path(project)
    expect(page).to have_content new_content
  end

  context 'destroy' do
    it 'author - ok', js: true do
      visit user_content_collect_info_posts_path(project)
      expect {
        click_link "destroy_aspect_#{aspect.id}"
        page.driver.browser.accept_js_confirms
        expect(current_path) == user_content_collect_info_posts_path(project)
      }.to change(Core::Aspect::Post, :count).by(-1)
    end
  end

  it 'created by current user' do
    click_link 'open_my_collect_info_posts'
    expect(page).to have_content aspect.content
  end
end
