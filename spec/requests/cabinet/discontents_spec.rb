require 'spec_helper'

describe 'Cabinet Discontents' do
  subject { page }
  let (:project) { create :core_project, status: Core::Project::STATUS_CODES[:discontent] }
  let (:core_project_user) { create :core_project_user, core_project: project }
  let (:user) { core_project_user.user }

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

  context 'create with simple form', js: true do
    before do
      click_link 'new_discontent_posts_simple'
    end

    it 'correct' do
      expect {
        fill_in 'discontent_post_content', with: 'new discontent'
        fill_in 'discontent_post_what', with: 'because'
        fill_in 'discontent_post_whered', with: 'because'
        fill_in 'discontent_post_whend', with: 'because'
        click_button 'send_post'
        expect(page).to have_content t('form.discontent.create_success')
      }.to change(Discontent::Post, :count).by(1)
    end

    it 'empty fields - error' do
      expect {
        click_button 'send_post'
        within :css, 'div#notice_messages' do
          expect(page).to have_css 'div.error_explanation'
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
        expect(page).to have_content t('form.discontent.create_success')
      }.to change(Discontent::Post, :count).by(1)
    end

    it 'empty fields - error' do
      expect {
        click_button 'send_post'
        within :css, 'div#notice_messages' do
          expect(page).to have_css 'div.error_explanation'
        end
      }.not_to change(Discontent::Post, :count)
    end
  end

  it 'created by current user' do
    discontent = create :discontent, user: user, project: project
    click_link 'open_my_discontent_posts'
    expect(page).to have_content discontent.content
  end
end
