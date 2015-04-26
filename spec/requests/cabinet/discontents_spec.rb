require 'spec_helper'

describe 'Cabinet Discontents' do
  subject { page }
  let (:project) { create :core_project, status: Core::Project::STATUS_CODES[:discontent] }
  let (:core_project_user) { create :core_project_user, core_project: project }
  let (:user) { core_project_user.user }
  let! (:discontent) { create :discontent, user: user, project: project }

  before do
    # тут еще нужно прицеплять техники к проекту
    #Rake::Task['seed:migrate'].invoke
    project.techniques << Technique::List.create(stage: 'discontent_posts', code: 'simple')
    project.techniques << Technique::List.create(stage: 'discontent_posts', code: 'detailed')

    sign_in user
    visit project_user_path(project, user)
  end

  it 'correct link to cabinet' do
    click_link 'open_cabinet'
    expect(current_path) == new_discontent_post_path(project, type_mechanic: 'simple')
  end

  it 'list forms for techniques' do
    project.techniques.each do |technique|
      expect(page).to have_content t("techniques.#{technique.name}")
    end
  end

  it 'close sticker' do
    expect(page).to have_content t('cabinet.discontent_posts_sticker')
    expect {
      click_link 'close_sticker'
    }.to change(UserCheck, :count).by(1)
    refresh_page
    expect(page).not_to have_content t('cabinet.discontent_posts_sticker')
  end

  describe 'create with simple form', js: true do
    let! (:aspect_1) { create :aspect, user: user, project: project }
    let! (:aspect_2) { create :aspect, user: user, project: project }

    before do
      click_link 'new_discontent_posts_simple'
    end

    context 'correct', js: true do
      before do
        find('#select_aspect').click
        execute_script("$('#discontent_post_aspects_#{aspect_1.id}').show()")
        execute_script("$('#discontent_post_aspects_#{aspect_2.id}').show()")
        find(:css, "#discontent_post_aspects_#{aspect_1.id}").set(true)
        find(:css, "#discontent_post_aspects_#{aspect_2.id}").set(true)
        fill_in 'discontent_post_content', with: 'new discontent'
        fill_in 'discontent_post_what', with: 'because'
        fill_in 'discontent_post_whered', with: 'because'
        fill_in 'discontent_post_whend', with: 'because'
        click_button 'send_post'
      end

      it { expect(page).to have_content t('form.discontent.new_success') }

      it { expect {}.to change(Discontent::Post, :count).by(1) }

      it { expect {}.to change(Discontent::PostAspect, :count).by(2) }
    end

    it 'empty fields - error' do
      expect {
        click_button 'send_post'
        within :css, 'div#notice_messages' do
          expect(page).to have_css 'div#error_explanation'
        end
      }.not_to change(Discontent::Post, :count)
    end
  end

  context 'create with detailed form', js: true do
    before do
      click_link 'new_discontent_posts_detailed'
      find('#first').click
    end

    it 'correct' do
      expect {
        fill_in 'discontent_post_content', with: 'new discontent'
        fill_in 'discontent_post_what', with: 'because'
        fill_in 'discontent_post_whered', with: 'because'
        fill_in 'discontent_post_whend', with: 'because'
        click_button 'send_post'
        expect(page).to have_content t('form.discontent.new_success')
      }.to change(Discontent::Post, :count).by(1)
    end
  end

  it 'edit', js: true do
    new_content = 'new cool content'
    visit user_content_discontent_posts_path(project)
    click_link "edit_discontent_#{discontent.id}"
    expect {
      fill_in 'discontent_post_content', with: new_content
      click_button 'send_post'
      expect(page).to have_content t('form.aspect.edit_success')
    }.not_to change(Discontent::Post, :count)
    visit user_content_discontent_posts_path(project)
    expect(page).to have_content new_content
  end

  context 'destroy' do
    it 'author - ok', js: true do
      visit user_content_discontent_posts_path(project)
      expect {
        click_link "destroy_discontent_#{discontent.id}"
        page.driver.browser.accept_js_confirms
        expect(current_path) == user_content_discontent_posts_path(project)
      }.to change(Discontent::Post, :count).by(-1)
    end
  end

  it 'created by current user' do
    click_link 'open_my_discontent_posts'
    expect(page).to have_content discontent.content
    discontent.post_aspects.each do |aspect|
      expect(page).to have_content aspect.content
    end
  end
end
