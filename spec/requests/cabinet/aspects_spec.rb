require 'rake'
require 'spec_helper'

describe 'Cabinet Aspects' do
  subject { page }
  let (:project) { create :core_project, status: Core::Project::STATUS_CODES[:collect_info] }
  let (:core_project_user) { create :core_project_user, core_project: project }
  let (:user) { core_project_user.user }

  before do
    # тут еще нужно прицеплять техники к проекту
    #Rake::Task['seed:migrate'].invoke
    technique_1 = Technique::List.create stage: 'aspect_posts', code: 'simple'
    project.techniques << technique_1

    sign_in user
    visit project_user_path(project, user)
  end

  it 'list forms for techniques' do
    project.techniques.each do |technique|
      expect(page).to have_content t("techniques.#{technique.name}")
    end
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
        expect(page).to have_content t('form.aspect.create_success')
      }.to change(Core::Aspect::Post, :count).by(1)
    end

    it 'empty fields - error' do
      expect {
        fill_in 'core_aspect_post_content', with: ''
        fill_in 'core_aspect_post_short_desc', with: ''
        click_button 'send_post_aspect'
        within :css, 'div#notice_messages' do
          expect(page).to have_css 'div.error_explanation'
        end
      }.not_to change(Core::Aspect::Post, :count)
    end
  end

  it 'created by current user' do
    aspect = create :aspect, user: user, project: project
    click_link 'open_my_collect_info_posts'
    expect(page).to have_content aspect.content
  end
end
